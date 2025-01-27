class Jvgrep < Formula
  desc "Grep for Japanese users of Vim"
  homepage "https://github.com/mattn/jvgrep"
  url "https://github.com/mattn/jvgrep/archive/v5.8.8.tar.gz"
  sha256 "dc3b5f77189bf8f91d7c8f48e3908dcf4dfea9fd12cd23e71deb54e3ea64d724"
  head "https://github.com/mattn/jvgrep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fa73d4fa22c06a91abae4fb577d8000897a95687de102fa09258a2f726801791" => :catalina
    sha256 "fa73d4fa22c06a91abae4fb577d8000897a95687de102fa09258a2f726801791" => :mojave
    sha256 "fa73d4fa22c06a91abae4fb577d8000897a95687de102fa09258a2f726801791" => :high_sierra
    sha256 "9ce50e79263cd67bc65562d830cdd0b8fc16050ad54856d215c8d0d6bc71b256" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system bin/"jvgrep", "Hello World!", testpath
  end
end
