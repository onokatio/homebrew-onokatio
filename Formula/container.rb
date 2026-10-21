class Container < Formula
  desc "Create and run Linux containers using lightweight VMs (balloon fork)"
  homepage "https://apple.github.io/container/documentation/"
  url "https://github.com/onokatio/container/archive/refs/tags/1.5.0-balloon.tar.gz"
  version "1.5.0-balloon"
  sha256 "401701a586ee00013147eac02021099d7b7bec53958fcdb3ff92925502ff074b"
  license "Apache-2.0"
  head "https://github.com/onokatio/container.git", branch: "balloon"

  bottle do
    root_url "https://github.com/onokatio/homebrew-onokatio/releases/download/container-1.5.0-balloon"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c82ad6d547ac66582509bc1ab7ea12ba68cc4b636615af274f15e4ae31786db9"
  end

  depends_on arch: :arm64
  depends_on macos: :tahoe

  # Upstream requires full Xcode 26 ("depends_on xcode:") because a plain
  # `swift build` also builds the test-support library, which needs a
  # swift-testing macro plugin only full Xcode ships. This machine only has
  # the Command Line Tools, so instead build each shipped executable as its
  # own product: none of them depend on the test-support library, so the
  # macro plugin is never needed.
  INSTALLED_PRODUCTS = %w[
    container container-apiserver container-core-images
    container-network-vmnet container-runtime-linux machine-apiserver k8s
  ].freeze

  def install
    if build.head?
      ENV["GIT_COMMIT"] = Utils.git_head
    else
      ENV["RELEASE_VERSION"] = version
    end

    INSTALLED_PRODUCTS.each do |product|
      system "swift", "build", "--product", product, *std_swift_args
    end

    release_dir = buildpath/".build/release"

    bin.install release_dir/"container"
    bin.install release_dir/"container-apiserver"
    libexec.install "scripts/ensure-container-stopped.sh"

    # Container requires binaries and plugins to be signed with specific entitlements
    codesign "--identifier=com.apple.container.cli", bin/"container"
    codesign "--identifier=com.apple.container.apiserver", bin/"container-apiserver"

    plugins = {
      "container-core-images"   => { source: "CoreImages",       entitlements: false },
      "container-network-vmnet" => { source: "NetworkVMNet",     entitlements: true  },
      "container-runtime-linux" => { source: "RuntimeLinux",     entitlements: true  },
      "machine-apiserver"       => { source: "MachineAPIServer", entitlements: false,
                                     resources: ["init", "create-user.sh"] },
      "k8s"                     => { source: "K8s",              entitlements: false,
                                     resources: ["kindnet.yaml"] },
    }
    plugins.each do |bin_name, opts|
      plugin_dir = libexec/"container-plugins/#{bin_name}"
      (plugin_dir/"bin").install release_dir/bin_name
      plugin_dir.install "Sources/Plugins/#{opts[:source]}/config.toml"
      opts[:resources]&.each do |resource|
        (plugin_dir/"resources").install "Sources/Plugins/#{opts[:source]}/Resources/#{resource}"
      end

      entitlement_args = []
      entitlement_args << "--entitlements=signing/#{bin_name}.entitlements" if opts[:entitlements]

      codesign "--prefix=com.apple.container.", *entitlement_args,
               plugin_dir/"bin/#{bin_name}"
    end

    generate_completions_from_executable bin/"container", "--generate-completion-script"

    # Relocate the binaries under libexec and replace them in bin with shim
    # wrappers. The CLI resolves its install root as the lexical grandparent
    # of the running executable (see Sources/ContainerPlugin/InstallRoot.swift),
    # so the binaries must live one directory below the keg root for the
    # bundled plugins under libexec/container-plugins/ to be discovered.
    # CONTAINER_INSTALL_ROOT is also exported by the wrappers for the code
    # paths that honour the environment variable.
    bin.env_script_all_files libexec, CONTAINER_INSTALL_ROOT: opt_prefix
  end

  def codesign(*args)
    system "/usr/bin/codesign", "-f", "-s", "-", *args
  end

  # container APIs aren't guaranteed to be backward compatible,
  # so we stop the system service to ensure no components are out of sync.
  # Ref: https://github.com/apple/container/issues/551#issuecomment-3246928923
  post_install_steps do
    run "ensure-container-stopped.sh", args: ["-a"], base: :libexec
  end

  def caveats
    <<~EOS
      This is onokatio's personal fork with usage-based virtio-balloon memory
      reclaim (onokatio/containerization@memory-ballooning), not the stock
      apple/container release.

      When starting container with `brew services`, no kernel is installed
      automatically. Install the recommended kernel before running containers:
        container system kernel set --recommended
    EOS
  end

  service do
    run [opt_bin/"container", "system", "start", "--disable-kernel-install"]
    working_dir var
    log_path var/"log/container.log"
    error_log_path var/"log/container.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/container --version")

    assert_match(/Error: (?:(?:interrupted: ")?internalError: ")?failed to list containers/,
                 shell_output("#{bin}/container list 2>&1", 1))
  end
end
