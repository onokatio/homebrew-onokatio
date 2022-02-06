# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Radicale < Formula
  include Language::Python::Virtualenv
  desc "CalDav and CardDav server"
  homepage "https://radicale.org/"
  url "https://github.com/Kozea/Radicale.git", :tag => "v3.1.4"
  version "3.1.4"
  sha256 ""
  license ""


  depends_on "python@3.10"

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "passlib" do
    url "https://files.pythonhosted.org/packages/b6/06/9da9ee59a67fae7761aab3ccc84fa4f3f33f125b370f1ccdb915bf967c11/passlib-1.7.4.tar.gz"
    sha256 "defd50f72b65c5402ab2c573830a6978e5f202ad0d984793c8dde2c4152ebe04"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  #resource "Radicale" do
  #  url "https://files.pythonhosted.org/packages/be/7e/59eeb15c2583e1b6e83ca614838e1013c2b942a4f4c85b13841fdfd11664/Radicale-3.1.4.tar.gz"
  #  sha256 "dddd6d5a0f3f31430fb4bebcee82275c1a946975d077e967a176fd61eefc054c"
  #end

  resource "libdecsync" do
    url "https://files.pythonhosted.org/packages/c1/b0/82f9ff5deb4db4bff439ed6f23ed10ccc49b193f60c15af342e217c5ab00/libdecsync-2.2.1.tar.gz"
    sha256 "32e923ce3ba6bfd54bf80d26694d0afd29625ab81e46301e88474de5af371b42"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "vobject" do
    url "https://files.pythonhosted.org/packages/da/ce/27c48c0e39cc69ffe7f6e3751734f6073539bf18a0cfe564e973a3709a52/vobject-0.9.6.1.tar.gz"
    sha256 "96512aec74b90abb71f6b53898dd7fe47300cc940104c4f79148f0671f790101"
  end


  def install
    venv = virtualenv_create(libexec,"python3")
    resources.each do |r|
      #if r.name == "Radicale"
      #  venv.pip_install_and_link r
      #else
        venv.pip_install r
      #end
    end
    venv.pip_install_and_link buildpath

  end

  def post_install
    #load external plugin
    if Pathname(HOMEBREW_PREFIX/"share/decsync-plugin").exist?
      Pathname(HOMEBREW_PREFIX/"share/decsync-plugin").each_child do |r|
        system "ln", "-s", r, libexec/"lib/python3.10/site-packages/"
      end
    end
  end

  service do
    run opt_bin/"radicale"
    keep_alive true
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
