# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class RadicaleDecsync < Formula
  include Language::Python::Virtualenv
  desc "Radicale storage plugin"
  homepage "https://radicale.org/"
  url "https://github.com/39aldo39/Radicale-DecSync.git", :tag => "v2.0.0"
  version "2.0.0"
  sha256 ""
  license ""


  depends_on "python@3.10"
  depends_on "radicale"

  def install
    #venv = Virtualenv.new "radicale", HOMEBREW_PREFIX/"opt/radicale/libexec", "python3"
    venv = virtualenv_create(libexec,"python3")
    venv.pip_install_and_link buildpath
    system "mkdir", "-p", share/"decsync-plugin"
    system "ln", "-s", libexec/"lib/python3.10/site-packages/radicale_storage_decsync", share/"decsync-plugin/"
    system "ln", "-s", libexec/"lib/python3.10/site-packages/radicale_storage_decsync-2.0.0-py3.10.egg-info", share/"decsync-plugin/"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test radicale`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
