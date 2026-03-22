class ContainerdShimNerdbox < Formula
  desc "containerd sandbox runtime using vms"
  homepage "https://github.com/containerd/nerdbox"
  license "Apache-2.0"
  head "https://github.com/containerd/nerdbox.git", branch: "main"

  resource ("kernel") do
    url "https://github.com/onokatio/nerdbox/releases/download/latest/nerdbox-kernel-arm64"
    sha256 "e63f006c84e2f4a4a9676d10df8b0a5afa6dbfcb6bd8ab94403cc95dbc6f4dd7"
  end
  resource ("initrd") do
    url "https://github.com/onokatio/nerdbox/releases/download/latest/nerdbox-initrd", using: :nounzip
    sha256 "56fe4714b55e06c620a27a0fed6ae36fa206120d906147dbbb0f478eb1660f69"
  end

  depends_on "go" => :build
  depends_on "e2fsprogs"
  depends_on "slp/krun/libkrun"

  def install
    system "make", "_output/containerd-shim-nerdbox-v1"
    bin.install Dir["_output/*"]
    resource("kernel").stage do
      bin.install "./nerdbox-kernel-arm64"
    end
    resource("initrd").stage do
      bin.install "./nerdbox-initrd"
    end
  end

  test do
  end
end
