class Libpng < Formula
  desc "Library for manipulating PNG images"
  homepage "http://www.libpng.org/pub/png/libpng.html"
  url "ftp://ftp.simplesystems.org/pub/libpng/png/src/libpng16/libpng-1.6.24.tar.xz"
  mirror "https://dl.bintray.com/homebrew/mirror/libpng-1.6.24.tar.xz"
  sha256 "7932dc9e5e45d55ece9d204e90196bbb5f2c82741ccb0f7e10d07d364a6fd6dd"

  patch :p0 do
    url "https://hg.mozilla.org/mozilla-central/raw-file/8fd07f16556c/media/libpng/apng.patch"
    sha256 "d54c919869b5120c6acd873d603b69788e16da7f112cb88b30c28e1724eab4fc"
  end

  keg_only :provided_pre_mountain_lion

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "test"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <png.h>

      int main()
      {
        png_structp png_ptr;
        png_ptr = png_create_write_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
        png_destroy_write_struct(&png_ptr, (png_infopp)NULL);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lpng", "-o", "test"
    system "./test"
  end
end
