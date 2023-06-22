#! /bin/bash

source ipalfs.env

PARALLEL=-j8

PACKAGES=$LFS/packages
BUILD_PACKAGES=$HOME/build

rm -rf $BUILD_PACKAGES

mkdir -pv $PACKAGES
mkdir -pv $BUILD_PACKAGES

cd $HOME

# CHAPTER 6

export LDFLAGS=-static

# M4

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/m4-1.4.19.tar.xz
cd m4-1.4.19
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)
make $PARALLEL
make DESTDIR=$LFS install-strip

# NCURSES

cd $BUILD_PACKAGES
tar xvzf $PACKAGES/ncurses-6.4.tar.gz
cd ncurses-6.4
sed -i s/mawk// configure
mkdir build
pushd build
../configure
make -C include
make -C progs tic
popd

# we go fully static, removed:
#            --with-shared                \
#            --with-cxx-shared            \

./configure --prefix=/usr                \
            --host=$LFS_TGT              \
            --build=$(./config.guess)    \
            --mandir=/usr/share/man      \
            --with-manpage-format=normal \
            --without-normal             \
            --without-debug              \
            --without-ada                \
            --without-shared             \
            --without-cxx-shared         \
            --disable-stripping          \
            --enable-widec
make $PARALLEL
make DESTDIR=$LFS TIC_PATH=$(pwd)/build/progs/tic install
ln -s libncursesw.a $LFS/usr/lib/libncurses.a

# BASH

cd $BUILD_PACKAGES
tar xvzf $PACKAGES/bash-5.2.15.tar.gz
cd bash-5.2.15
# patch inverted logic bug if we have strtoimax
sed -i 's/bash_cv_func_strtoimax = yes/bash_cv_func_strtoimax = no/' m4/strtoimax.m4
autoconf -f
./configure --prefix=/usr \
            --build=$(sh support/config.guess) \
            --host=$LFS_TGT                    \
            --without-bash-malloc              \
            --enable-static-link
make $PARALLEL
make DESTDIR=$LFS install-strip
ln -sv bash $LFS/bin/sh

# COREUTILS

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/coreutils-9.1.tar.xz
cd coreutils-9.1
./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --enable-install-program=hostname \
            --enable-no-install-program=kill,uptime
make $PARALLEL
make DESTDIR=$LFS install-strip
mv -v $LFS/usr/bin/chroot              $LFS/usr/sbin
mkdir -pv $LFS/usr/share/man/man8
mv -v $LFS/usr/share/man/man1/chroot.1 $LFS/usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/'                    $LFS/usr/share/man/man8/chroot.8

# DIFFUTILS

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/diffutils-3.9.tar.xz
cd diffutils-3.9
./configure --prefix=/usr --host=$LFS_TGT
make $PARALLEL
make DESTDIR=$LFS install-strip

# FILE

export CFLAGS="-static"

# build static libraries, not shared

cd $BUILD_PACKAGES
tar xvzf $PACKAGES/file-5.44.tar.gz
cd file-5.44
mkdir build
pushd build
  ../configure --disable-bzlib      \
               --disable-libseccomp \
               --disable-xzlib      \
               --disable-zlib       \
               --disable-shared     \
               --enable-static
  make
popd
./configure --prefix=/usr --host=$LFS_TGT --build=$(./config.guess) \
               --disable-shared     \
               --enable-static
make LDFLAGS=-all-static $PARALLEL FILE_COMPILE=$(pwd)/build/src/file
make DESTDIR=$LFS install-strip
rm -v $LFS/usr/lib/libmagic.la

# FINDUTILS

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/findutils-4.9.0.tar.xz
cd findutils-4.9.0
./configure --prefix=/usr                   \
            --localstatedir=/var/lib/locate \
            --host=$LFS_TGT                 \
            --build=$(build-aux/config.guess)
make $PARALLEL
make DESTDIR=$LFS install-strip

# GAWK

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/gawk-5.2.0.tar.xz
cd gawk-5.2.0
sed -i 's/extras//' Makefile.in
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)
make $PARALLEL
make DESTDIR=$LFS install-strip

# GREP

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/grep-3.8.tar.xz
cd grep-3.8
./configure --prefix=/usr   \
            --host=$LFS_TGT
make $PARALLEL
make DESTDIR=$LFS install-strip

# GZIP

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/gzip-1.12.tar.xz
cd gzip-1.12
./configure --prefix=/usr   \
            --host=$LFS_TGT
make $PARALLEL
make DESTDIR=$LFS install-strip

# MAKE

cd $BUILD_PACKAGES
tar xvzf $PACKAGES/make-4.4.tar.gz
cd make-4.4
sed -e '/ifdef SIGPIPE/,+2 d' \
    -e '/undef  FATAL_SIG/i FATAL_SIG (SIGPIPE);' \
    -i src/main.c
./configure --prefix=/usr   \
            --without-guile \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)
make $PARALLEL
make DESTDIR=$LFS install-strip

# PATCH

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/patch-2.7.6.tar.xz
cd patch-2.7.6
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)
make $PARALLEL
make DESTDIR=$LFS install-strip

# SED

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/sed-4.9.tar.xz
cd sed-4.9
./configure --prefix=/usr   \
            --host=$LFS_TGT
make $PARALLEL
make DESTDIR=$LFS install-strip

# TAR

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/tar-1.34.tar.xz
cd tar-1.34
./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess)
make $PARALLEL
make DESTDIR=$LFS install-strip

# XZ

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/xz-5.4.1.tar.xz
cd xz-5.4.1
# removed:
#            --disable-static                  \
./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --docdir=/usr/share/doc/xz-5.4.1 \
            --disable-shared
make LDFLAGS=-all-static $PARALLEL
make DESTDIR=$LFS install-strip
rm -v $LFS/usr/lib/*.la

# Strip

strip $LFS/usr/bin/{clear,infocmp,tabs,tic,tac,toe,tput,tset}

echo "CHAPTER 6 (almost) DONE"

