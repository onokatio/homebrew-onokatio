class Nerdctl < Formula
  desc "ContaiNERD CTL - Docker-compatible CLI for containerd"
  homepage "https://github.com/containerd/nerdctl"
  url "https://github.com/containerd/nerdctl/archive/refs/tags/v2.4.2.tar.gz"
  sha256 "f73026262a1cab7b6a8f3df66da54dbe52268184359c41408468d9b75d3b41d8"
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
