class Kf5Karchive < Formula
  desc "Qt 5 addon providing access to numerous types of archives"
  homepage "https://www.kde.org"
  url "https://download.kde.org/stable/frameworks/5.44/karchive-5.44.0.tar.xz"
  sha256 "b2d8d8e945515870b363ad98ac90a94103056afd5d7c57d5148b12a673b2bb02"

  head "git://anongit.kde.org/karchive.git"

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "KDE-mac/kde/kf5-extra-cmake-modules" => :build

  depends_on "qt"
  depends_on "zlib"
  depends_on "bzip2"
  depends_on "xz"

  def install
    args = std_cmake_args
    args << "-DBUILD_TESTING=OFF"
    args << "-DBUILD_QCH=ON"
    args << "-DKDE_INSTALL_QMLDIR=lib/qt5/qml"
    args << "-DKDE_INSTALL_PLUGINDIR=lib/qt5/plugins"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
      prefix.install "install_manifest.txt"
    end
  end
end
