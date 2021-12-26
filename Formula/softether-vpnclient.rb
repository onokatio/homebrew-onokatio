# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class SoftetherVpnclient < Formula
  desc ""
  homepage ""
  url "https://github.com/SoftEtherVPN/SoftEtherVPN_Stable/releases/download/v4.38-9760-rtm/softether-vpnclient-v4.38-9760-rtm-2021.08.17-macos-x64-64bit.tar.gz"
  sha256 "8314fa05f1782b5cfc7f2928c404674b3b0000eb98717cd8ccc9ef78fb59c691"
  license ""

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    # Remove unrecognized options if warned by configure
    # https://rubydoc.brew.sh/Formula.html#std_configure_args-instance_method
    system "arch -x86_64 make"
    system "mkdir -p #{prefix}/bin"
    system "cp ./vpnclient #{prefix}/bin/vpnclient"
    system "cp ./vpncmd #{prefix}/bin/vpncmd"
    system "cp ./hamcore.se2 #{prefix}/bin/hamcore.se2"
    # system "cmake", "-S", ".", "-B", "build", *std_cmake_args
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test softether-vpnclient`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
