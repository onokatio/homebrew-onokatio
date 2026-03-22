class Nerdctl < Formula
  desc "ContaiNERD CTL - Docker-compatible CLI for containerd"
  homepage "https://github.com/containerd/nerdctl"
  url "https://github.com/containerd/nerdctl/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "f39c34d3a285e087f2b2869f06fea343d8285ad9bfb9417b9c5b6dd4e78d6fad"
  license "Apache-2.0"
  head "https://github.com/containerd/nerdctl.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/containerd/nerdctl/v2/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/nerdctl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nerdctl --version")
  end
end
