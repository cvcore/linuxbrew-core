class Ucl < Formula
  desc "Data compression library with small memory footprint"
  homepage "https://www.oberhumer.com/opensource/ucl/"
  url "https://www.oberhumer.com/opensource/ucl/download/ucl-1.03.tar.gz"
  sha256 "b865299ffd45d73412293369c9754b07637680e5c826915f097577cd27350348"

  bottle do
    cellar :any_skip_relocation
    sha256 "5de2305d5da25469e7bf27d2e776a6e22b20806940ad1dea16d18b39a1125f7e" => :catalina
    sha256 "b676bbfb2ff44a3ff71e96a11bc8ae86ea2466029faea800427196d3ece8261e" => :mojave
    sha256 "95bba447faa9e980720b780e1db69bf59e72f026a19a965bbb1b18f3de9230de" => :high_sierra
    sha256 "b2019331517fea2505cb2d25eebbdf6ceb9a45378525d0e36a096ea3c45ad9a8" => :sierra
    sha256 "d56b0d36a68a2bc558742eac0c6632612180797cc45520389b5d87f09c23b1bd" => :el_capitan
    sha256 "32a54309c092854fc5a4a443a1e9d33fb677ff257d983ea7d5b0eb7bb90d3b2e" => :yosemite
    sha256 "3c334012766dce80dac49d279be1be1ae4a1fc5df188cc19a25ba1bec84305a9" => :mavericks
    sha256 "07864b07361fc18ca17ff2c8e4bdfc04a51bdc440f289bd824faadaf3fdd28b5" => :x86_64_linux
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      // simplified version of
      // https://github.com/korczis/ucl/blob/HEAD/examples/simple.c
      #include <stdio.h>
      #include <ucl/ucl.h>
      #include <ucl/uclconf.h>
      #define IN_LEN      (128*1024L)
      #define OUT_LEN     (IN_LEN + IN_LEN / 8 + 256)
      int main(int argc, char *argv[]) {
          int r;
          ucl_byte *in, *out;
          ucl_uint in_len, out_len, new_len;

          if (ucl_init() != UCL_E_OK) { return 4; }
          in = (ucl_byte *) ucl_malloc(IN_LEN);
          out = (ucl_byte *) ucl_malloc(OUT_LEN);
          if (in == NULL || out == NULL) { return 3; }

          in_len = IN_LEN;
          ucl_memset(in,0,in_len);

          r = ucl_nrv2b_99_compress(in,in_len,out,&out_len,NULL,5,NULL,NULL);
          if (r != UCL_E_OK) { return 2; }
          if (out_len >= in_len) { return 0; }
          r = ucl_nrv2b_decompress_8(out,out_len,in,&new_len,NULL);
          if (r != UCL_E_OK && new_len == in_len) { return 1; }
          ucl_free(out);
          ucl_free(in);
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lucl", "-o", "test"
    system "./test"
  end
end
