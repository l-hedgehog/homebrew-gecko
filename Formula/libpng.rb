class Libpng < Formula
  desc "Library for manipulating PNG images"
  homepage "http://www.libpng.org/pub/png/libpng.html"
  url "ftp://ftp.simplesystems.org/pub/libpng/png/src/libpng16/libpng-1.6.23.tar.xz"
  mirror "https://dl.bintray.com/homebrew/mirror/libpng-1.6.23.tar.xz"
  sha256 "6d921e7bdaec56e9f6594463ec1fe1981c3cd2d5fc925d3781e219b5349262f1"

  patch :p0 do
    url "https://hg.mozilla.org/mozilla-central/raw-file/7f9d9dfa09d2/media/libpng/apng.patch"
    sha256 "d30f47ef71789192da2f5a549b54c938673cec8e575380f27350f0eda24fd43a"
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
