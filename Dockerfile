FROM alpine:latest

# https://mirrors.alpinelinux.org/
RUN sed -i 's@dl-cdn.alpinelinux.org@ftp.halifax.rwth-aachen.de@g' /etc/apk/repositories

RUN apk update
RUN apk upgrade

# required by qemu
RUN apk add --no-cache \
 make \
 samurai \
 perl \
 python3 python3-dev \
 gcc \
 libc-dev \
 pkgconf \
 linux-headers \
 zlib-dev zlib-static \
 zstd-dev zstd-static \
 pcre2-dev pcre2-static \
 flex swig bison py3-setuptools \
 libgcrypt-dev libgcrypt-static nettle-dev nettle-static libgpg-error-dev libgpg-error-static \
 lzo-dev passt gmp-dev gmp-static \
 bash xz git patch aria2 curl cmake \
 gettext gettext-dev autoconf automake libtool


# required to compile Slirp as static lib and qemu-system
RUN apk add --no-cache \
 bzip2-static ncurses-static \
 libxkbcommon-static libxkbcommon-dev \
 libx11-static zstd-static \
 git meson ninja-build gettext-static libjpeg-turbo-static cyrus-sasl-static \
 build-base liburing-dev libaio-dev alpine-sdk \
 libsndfile-static libsndfile-dev openssl-libs-static \
 lz4-static pixman-static pixman-dev libudev-zero-dev libcap-static libcap-ng-static libcap-ng-dev
 
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
