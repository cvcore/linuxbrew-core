class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://software.ecmwf.int/wiki/download/attachments/45757960/eccodes-2.18.0-Source.tar.gz"
  sha256 "d88943df0f246843a1a062796edbf709ef911de7269648eef864be259e9704e3"

  bottle do
    sha256 "0fb7a83f5bee61fa6a8fffd42e1c85a4d346ff29138c5cb3ecfbce71f3ef1219" => :catalina
    sha256 "9433af73710db4cd672ef9fde0e05d18709d37bb89e826a2de638110c9c0a61b" => :mojave
    sha256 "0764fe043a83858da925b7d55367ee7c516e1d351009e3e6bde6c611944a3e9d" => :high_sierra
    sha256 "39e15894bc036c18e89f64bc0cfead0ef6de113682a7a8bbaf8bba301373090e" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "jasper"
  depends_on "libpng"
  depends_on "netcdf"

  def install
    inreplace "CMakeLists.txt", "find_package( OpenJPEG )", ""

    mkdir "build" do
      system "cmake", "..", "-DENABLE_NETCDF=ON", "-DENABLE_PNG=ON",
                            "-DENABLE_PYTHON=OFF", *std_cmake_args
      system "make", "install"
    end

    # Avoid references to Homebrew shims directory
    os = OS.mac? ? "mac" : "linux"
    cc = OS.mac? ? "clang" : "gcc"
    path = HOMEBREW_LIBRARY/"Homebrew/shims/#{os}/super/#{cc}"
    inreplace include/"eccodes_ecbuild_config.h", path, "/usr/bin/#{cc}"
    inreplace lib/"pkgconfig/eccodes.pc", path, "/usr/bin/#{cc}"
    inreplace lib/"pkgconfig/eccodes_f90.pc", path, "/usr/bin/#{cc}"
  end

  test do
    grib_samples_path = shell_output("#{bin}/codes_info -s").strip
    assert_match "packingType", shell_output("#{bin}/grib_ls #{grib_samples_path}/GRIB1.tmpl")
    assert_match "gridType", shell_output("#{bin}/grib_ls #{grib_samples_path}/GRIB2.tmpl")
  end
end
