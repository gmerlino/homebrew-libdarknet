class Libdarknet < Formula
  desc "Convolutional Neural Networks"
  homepage "http://pjreddie.com/darknet/"
  head "https://github.com/OrKoN/darknet.git"

  depends_on "pkg-config" => :run
  depends_on "opencv@2" => :build

  patch :DATA

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "true"
  end
end

__END__
diff --git a/Makefile b/Makefile
index 8d7517b..d74be2a 100644
--- a/Makefile
+++ b/Makefile
@@ -16,7 +16,8 @@ ARCH= -gencode arch=compute_20,code=[sm_20,sm_21] \
 # ARCH= -gencode arch=compute_52,code=compute_52
 
 VPATH=./src/:./examples
-SLIB=libdarknet.so
+#SLIB=libdarknet.so
+SLIB=libdarknet.dylib
 ALIB=libdarknet.a
 EXEC=darknet
 OBJDIR=./obj/
@@ -82,7 +83,8 @@ $(ALIB): $(OBJS)
 	$(AR) $(ARFLAGS) $@ $^
 
 $(SLIB): $(OBJS)
-	$(CC) $(CFLAGS) -shared $^ -o $@ $(LDFLAGS)
+#	$(CC) $(CFLAGS) -shared $^ -o $@ $(LDFLAGS)
+	$(CC) $(CFLAGS) -dynamiclib $^ -o $@ $(LDFLAGS)
 
 $(OBJDIR)%.o: %.c $(DEPS)
 	$(CC) $(COMMON) $(CFLAGS) -c $< -o $@
@@ -108,8 +110,10 @@ clean:
 .PHONY: install
 
 install:
+	mkdir -p $(PREFIX)/lib
 	mkdir -p $(PREFIX)/include/darknet
 	cp libdarknet.a $(PREFIX)/lib/libdarknet.a
+	cp libdarknet.dylib $(PREFIX)/lib/libdarknet.dylib
 	cp ${HEADERS} include/darknet.h $(PREFIX)/include/darknet
 
 .PHONY: uninstall
