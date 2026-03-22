# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://docs.brew.sh/rubydoc/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Containerd < Formula
  desc "An open and reliable container runtime"
  homepage "https://containerd.io"
  url "https://github.com/containerd/containerd/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "86e7a268fc73f5332522baef86082c1d6c17986e2957a9ad842ead35d1080fca"
  license "Apache-2.0"
  head "https://github.com/containerd/containerd.git", branch: "main"

  depends_on "go" => :build
  depends_on "e2fsprogs"
  depends_on "containerd-shim-nerdbox"

  on_macos do
    resource "config" do
      url "https://raw.githubusercontent.com/containerd/nerdbox/6f751faad1a1c11088c4bfa714dd18e482b08d45/examples/macos/config.toml"
      sha256 "b1ff3278f24cf5f72a9f579028c3ffa920e012a5f0083341f42f745971eb3c1c"
    end
  end

  def install
    ENV["PREFIX"] = prefix
    system "make"
    system "make install"
  end

  def post_install
    if OS.mac?
      # Install mac specific erofs config from nerdbox repo
      resource("config").stage do
        pkgetc.install "config.toml"
      end
    end
  end

  service do
    run macos: [opt_bin/"containerd", "--config", etc/"containerd/config.toml"]
    environment_variables PATH: "#{HOMEBREW_PREFIX}/opt/e2fsprogs/sbin:#{std_service_path_env}"
  log_path var/"log/containerd/stdout.log"
  error_log_path var/"log/containerd/stderr.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ctr --version")
    assert_match version.to_s, shell_output("#{bin}/containerd --version")
  end

  def caveats
    <<~EOS
      To use in MacOS, Please create yourself:

      $ sudo mkdir /var/run/containerd
      $ sudo chown $USER /var/run/containerd
    EOS
  end
end
