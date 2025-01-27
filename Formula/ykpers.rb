class Ykpers < Formula
  desc "YubiKey personalization library and tool"
  homepage "https://developers.yubico.com/yubikey-personalization/"
  url "https://developers.yubico.com/yubikey-personalization/Releases/ykpers-1.20.0.tar.gz"
  sha256 "0ec84d0ea862f45a7d85a1a3afe5e60b8da42df211bb7d27a50f486e31a79b93"

  bottle do
    cellar :any
    sha256 "0b11199f0ee0d96c456d700043073eaea499a2e379ce21ce3fd13fe826f3a667" => :catalina
    sha256 "5a77e8978ad9cf3ed1d596d5ec209cf94a4eb1f13ec7b7b228847c6d6241e662" => :mojave
    sha256 "5907731c71ecd35c52caebbda5b1cd2bca595a06d2a1571c3ffeadb745e33054" => :high_sierra
    sha256 "1f2863cf8132643dc9c3572b649792430d3fc932a5e6d49709a7076b10718d8c" => :sierra
    sha256 "97bcace6f732a13023c70e86d39d63f9eb86a88b19c139edb5550b677bed40d1" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "libyubikey"

  on_linux do
    depends_on "libusb"
  end

  def install
    backend = OS.mac? ? "osx" : "libusb-1.0"
    libyubikey_prefix = Formula["libyubikey"].opt_prefix
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-libyubikey-prefix=#{libyubikey_prefix}",
                          "--with-backend=#{backend}"
    system "make", "check"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ykinfo -V 2>&1")
  end
end
