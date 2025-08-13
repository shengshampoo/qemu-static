#! /bin/bash
#build some static lib only for qemu 9.2
WORKSPACE=/tmp/workspace
mkdir -p $WORKSPACE

#libslirp
cd $WORKSPACE
aria2c -x2 -R https://gitlab.freedesktop.org/slirp/libslirp/-/archive/master/libslirp-master.tar.bz2
tar -vxf libslirp-master.tar.bz2
cd libslirp-master
meson setup --default-library static build 
ninja -C build install 


#libusb
cd $WORKSPACE
aria2c -x2 -R https://downloads.sourceforge.net/project/libusb/libusb-1.0/libusb-1.0.29/libusb-1.0.29.tar.bz2
tar -xjf libusb-1.0.29.tar.bz2
cd libusb-1.0.29
mkdir -p ./build ./build2
cd build
../configure
make -j8
make install
#libusb static
cd $WORKSPACE/libusb-1.0.29/build2
../configure --enable-static --disable-shared
make -j8
make install


#libusb-compat
cd $WORKSPACE
aria2c -x2 -R https://downloads.sourceforge.net/project/libusb/libusb-compat-0.1/libusb-compat-0.1.7/libusb-compat-0.1.7.tar.bz2
tar -vxf libusb-compat-0.1.7.tar.bz2
cd libusb-compat-0.1.7
mkdir build 
cd build
../configure --enable-static --disable-shared
make -j8
make install


#usbredir
cd $WORKSPACE
aria2c -x2 -R https://www.spice-space.org/download/usbredir/usbredir-0.15.0.tar.xz
tar -vxf usbredir-0.15.0.tar.xz
cd usbredir-0.15.0
mkdir build
cd build
meson setup --buildtype=release -Ddefault_library=static ..
ninja
ninja install


#fuse
cd $WORKSPACE
aria2c -x2 -R https://github.com/libfuse/libfuse/releases/download/fuse-3.17.3/fuse-3.17.3.tar.gz
tar -vxf fuse-3.17.3.tar.gz
cd fuse-3.17.3
mkdir build
cd build
meson setup --buildtype=release -Ddefault_library=static ..
ninja
ninja install


#SDL2
cd $WORKSPACE
aria2c -x2 -R https://github.com/libsdl-org/SDL/releases/download/release-2.32.8/SDL2-2.32.8.tar.gz
tar -vxf SDL2-2.32.8.tar.gz
cd SDL2-2.32.8
mkdir build
cd build 
../configure --enable-static --disable-shared --enable-pulseaudio
make -j8 && make install


#SDL2_image
cd $WORKSPACE
aria2c -x2 -R https://github.com/libsdl-org/SDL_image/releases/download/release-2.8.8/SDL2_image-2.8.8.tar.gz
tar -vxf SDL2_image-2.8.8.tar.gz
cd SDL2_image-2.8.8
mkdir build
cd build 
../configure --enable-static --disable-shared 
make -j8 && make install

#vnc
cd $WORKSPACE
aria2c -x2 -R https://github.com/LibVNC/libvncserver/archive/refs/tags/LibVNCServer-0.9.15.tar.gz
tar -vxf libvncserver-LibVNCServer-0.9.15.tar.gz
cd libvncserver-LibVNCServer-0.9.15
mkdir build
cd build
cmake .. -DBUILD_SHARED_LIBS=OFF
make -j8 && make install 

# dtc libfdt
cd $WORKSPACE
git clone https://git.kernel.org/pub/scm/utils/dtc/dtc.git
cd dtc
meson setup builddir -Dprefix=/usr --strip 
cd builddir 
ninja && DESTDIR=/ ninja install

#clean
rm -rf $WORKSPACE
