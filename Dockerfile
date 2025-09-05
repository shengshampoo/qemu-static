FROM chimeralinux/chimera


RUN apk update
RUN apk upgrade

# required by qemu
RUN apk add --no-cache \
 gmake \
 perl chimera-repo-user \
 python python-devel \
 libatomic-chimera-devel libatomic-chimera-devel-static libarchive-progs libgcc-chimera cargo rust rust-src rust-bindgen rust-std \
 clang clang-devel clang-devel-static libunwind-devel libunwind-devel-static \
 pkgconf \
 linux-headers \
 zlib-ng-compat-devel zlib-ng-compat-devel-static \
 zstd-devel zstd-devel-static \
 pcre2-devel pcre2-devel-static \
 flex swig bison python-setuptools \
 libgcrypt-devel libgcrypt-devel-static nettle-devel nettle-devel-static \
 lzo-devel-static lzo-devel passt gmp-devel gmp-devel-static \
 bash xz git chimerautils-extra aria2 curl cmake \
 gettext gettext-devel autoconf automake libtool sqlite-devel sqlite-devel-static


# required to compile Slirp as static lib and qemu-system
RUN apk add --no-cache \
 bzip2-devel bzip2-devel-static ncurses-devel-static \
 libpng-devel libpng-devel-static \
 libxkbcommon-devel-static libxkbcommon-devel \
 libx11-devel-static libunwind-devel libunwind-devel-static libbsd-devel libbsd-devel-static \
 git meson ninja gettext-devel-static \
 liburing-devel-static liburing-devel libaio-devel-static libaio-devel \
 openssl3-devel-static openssl3-devel \
 lz4-devel-static lz4-devel pixman-devel-static pixman-devel udev-devel-static udev-devel libcap-devel-static libcap-ng-devel-static libcap-ng-devel
 
RUN aria2c -x2 -R https://raw.githubusercontent.com/shengshampoo/qemu-static/refs/heads/master/build-static-lib.sh && \
chmod +x build-static-lib.sh && ./build-static-lib.sh
    


# additional

WORKDIR /work

COPY command/base command/base
COPY command/fetch command/fetch
RUN /work/command/fetch

COPY command/extract command/extract
RUN /work/command/extract

COPY patch patch
COPY command/patch command/patch
RUN /work/command/patch

COPY command/configure command/configure
RUN /work/command/configure

COPY command/make command/make
RUN /work/command/make

COPY command/install command/install
RUN /work/command/install

COPY command/package command/package
RUN /work/command/package
