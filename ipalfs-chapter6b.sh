#! /bin/bash

source ipalfs.env

PARALLEL=-j8

PACKAGES=$LFS/packages
BUILD_PACKAGES=$HOME/build

rm -rf $BUILD_PACKAGES

mkdir -pv $PACKAGES
mkdir -pv $BUILD_PACKAGES

cd $HOME

# CHAPTER 6 (cont.)

export LDFLAGS=-static

# BINUTILS

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/binutils-2.40.tar.xz
cd binutils-2.40
mkdir build
cd build
../configure                   \
    --prefix=/usr              \
    --build=$(../config.guess) \
    --host=$LFS_TGT            \
    --disable-nls              \
    --disable-shared           \
    --enable-static            \
    --enable-gprofng=no        \
    --disable-werror           \
    --enable-64-bit-bfd
make configure-host
make LDFLAGS=-all-static $PARALLEL
make DESTDIR=$LFS install-strip
rm -f $LFS/lib/*.la

# GCC

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/gcc-12.2.0.tar.xz
cd gcc-12.2.0
./contrib/download_prerequisites
#sed '/thread_header =/s/@.*@/gthr-posix.h/' \
#    -i libgcc/Makefile.in libstdc++-v3/include/Makefile.in
mkdir build
cd build
../configure                                       \
    --build=$(../config.guess)                     \
    --host=$LFS_TGT                                \
    --target=$LFS_TGT                              \
    LDFLAGS_FOR_TARGET=-L$PWD/$LFS_TGT/libgcc      \
    --prefix=/usr                                  \
    --with-build-sysroot=$LFS                      \
    --enable-default-pie                           \
    --enable-default-ssp                           \
    --disable-nls                                  \
    --disable-multilib                             \
    --disable-libatomic                            \
    --disable-libgomp                              \
    --disable-libquadmath                          \
    --disable-libssp                               \
    --disable-libvtv                               \
    --disable-shared                \
    --disable-host-shared           \
    --with-boot-ldflags=-static     \
    --with-stage1-ldflags=-static   \
    --enable-languages=c,c++
make $PARALLEL
make DESTDIR=$LFS install-strip
ln -sv gcc $LFS/usr/bin/cc

