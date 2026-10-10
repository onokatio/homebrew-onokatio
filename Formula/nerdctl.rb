class Nerdctl < Formula
  desc "ContaiNERD CTL - Docker-compatible CLI for containerd"
  homepage "https://github.com/containerd/nerdctl"
  url "https://github.com/containerd/nerdctl/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "ddae9bac35fe8ad35a631d64a179d17589bed3055756f94ef59cf2e0b2a95ee7"
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
