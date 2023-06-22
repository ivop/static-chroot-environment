#! /bin/bash

source ipalfs.env

PARALLEL=-j8

PACKAGES=$LFS/packages
BUILD_PACKAGES=$HOME/build

mkdir -pv $PACKAGES
rm -rf $BUILD_PACKAGES
mkdir -pv $BUILD_PACKAGES

cd $HOME

# symlinks, we do not patch stuff and no multilib

mkdir -pv $LFS/{etc,var} $LFS/usr/{bin,lib,sbin}
ln -s lib $LFS/usr/lib64
for i in bin lib sbin lib64; do
    ln -svf usr/$i $LFS/$i
done

# CHAPTER 5

# BINUTILS

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/binutils-2.40.tar.xz
cd binutils-2.40
mkdir build
cd build
../configure --prefix=$LFS/tools \
             --with-sysroot=$LFS \
             --target=$LFS_TGT   \
             --disable-nls       \
             --enable-gprofng=no \
             --disable-werror
# meh, errors with parallel build
make configure-host
make LDFLAGS=-all-static
make install-strip

# GCC

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/gcc-12.2.0.tar.xz
cd gcc-12.2.0
./contrib/download_prerequisites
mkdir build
cd build
../configure                  \
    --target=$LFS_TGT         \
    --prefix=$LFS/tools       \
    --with-glibc-version=2.37 \
    --with-sysroot=$LFS       \
    --with-newlib             \
    --without-headers         \
    --enable-default-pie      \
    --enable-default-ssp      \
    --disable-nls             \
    --disable-shared          \
    --disable-host-shared     \
    --disable-multilib        \
    --disable-threads         \
    --disable-libatomic       \
    --disable-libgomp         \
    --disable-libquadmath     \
    --disable-libssp          \
    --disable-libvtv          \
    --disable-libstdcxx       \
    --with-boot-ldflags=-static   \
    --with-stage1-ldflags=-static \
    --enable-languages=c,c++
make $PARALLEL
make install-strip
cd ..
cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
  `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/install-tools/include/limits.h

# KERNEL 6.1.11 HEADERS

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/linux-6.1.11.tar.xz
cd linux-6.1.11
make mrproper
make headers
find usr/include -type f ! -name '*.h' -delete
cp -rv usr/include $LFS/usr

# MUSL

cd $BUILD_PACKAGES
tar xvzf $PACKAGES/musl-1.2.3.tar.gz
cd musl-1.2.3
mkdir build
cd build
../configure                            \
        --prefix=/usr                   \
        --disable-shared
make $PARALLEL
make DESTDIR=$LFS install

# LIBSTDC++

cd $BUILD_PACKAGES
cd gcc-12.2.0
mkdir build-libstdc++
cd build-libstdc++
../libstdc++-v3/configure           \
    --host=$LFS_TGT                 \
    --build=$(../config.guess)      \
    --prefix=/usr                   \
    --disable-multilib              \
    --disable-nls                   \
    --disable-libstdcxx-pch         \
    --disable-shared                \
    --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/12.2.0
make $PARALLEL
make DESTDIR=$LFS install
rm -f $LFS/usr/lib/lib{stdc++,stdc++fs,supc++}.la
rm -f $LFS/bin/bin $LFS/lib/lib $LFS/lib64/lib64 $LFS/sbin/sbin

# DONE

cd $HOME

echo CHAPTER 5 DONE

