class Nerdctl < Formula
  desc "ContaiNERD CTL - Docker-compatible CLI for containerd"
  homepage "https://github.com/containerd/nerdctl"
  url "https://github.com/containerd/nerdctl/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "105bead380f5f0d342506939d82793869604f61a88fdacd07b26e6a4d2521236"
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
