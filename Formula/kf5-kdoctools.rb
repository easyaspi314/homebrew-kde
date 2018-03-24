class Kf5Kdoctools < Formula
  desc "Documentation generation from docbook"
  homepage "https://www.kde.org"
  url "https://download.kde.org/stable/frameworks/5.44/kdoctools-5.44.0.tar.xz"
  sha256 "2316687ead1d11793670311f037c35e8535effe9e0967b143471e5ac92cdcc90"

  head "git://anongit.kde.org/kdoctools.git"

  depends_on "cmake" => :build
  depends_on "perl" => :build
  depends_on "gettext" => :build
  depends_on "KDE-mac/kde/kf5-extra-cmake-modules" => :build
  depends_on "KDE-mac/kde/kf5-ki18n" => :build

  depends_on "docbook-xsl"
  depends_on "libxml2"
  depends_on "libxslt"
  depends_on "KDE-mac/kde/kf5-karchive"

  # We need URI::Escape or the CMake will fail.
  # Adapted from the Rex Formula
  resource "URI::Escape" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/URI-1.73.tar.gz"
    sha256 "cca7ab4a6f63f3ccaacae0f2e1337e8edf84137e73f18548ec7d659f23efe413"
  end

  def install
    # Adapted from the Rex Formula
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    ENV.prepend_path "PERL5LIB", libexec/"lib"
    
    resources.each do |res|
      res.stage do
        perl_build
      end
    end

    args = std_cmake_args
    args << "-DBUILD_TESTING=OFF"
    args << "-DKDE_INSTALL_QMLDIR=lib/qt5/qml"
    args << "-DKDE_INSTALL_PLUGINDIR=lib/qt5/plugins"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
      prefix.install "install_manifest.txt"
    end
  end

  def caveats; <<~EOS
    You need to take some manual steps in order to make this formula work:
      ln -sf "$(brew --prefix)/share/kf5" "$HOME/Library/Application Support"
    EOS
  end

  # Adapted from the Rex Formula
  private

  def perl_build
    if File.exist? "Makefile.PL"
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make", "PERL5LIB=#{ENV["PERL5LIB"]}"
      system "make", "install"
    elsif File.exist? "Build.PL"
      system "perl", "Build.PL", "--install_base", libexec
      system "./Build", "PERL5LIB=#{ENV["PERL5LIB"]}"
      system "./Build", "install"
    else
      raise "Unknown build system for #{res.name}"
    end
  end
end
