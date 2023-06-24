#! /bin/bash

set +h
set -ex
umask 022
export PATH=/sbin:/bin

PARALLEL=-j8

PACKAGES=$LFS/packages
BUILD_PACKAGES=$HOME/build

rm -rf $BUILD_PACKAGES
mkdir -pv $BUILD_PACKAGES

export LDFLAGS=-static

# GETTEXT

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/gettext-0.21.1.tar.xz
cd gettext-0.21.1
./configure --disable-shared --enable-static
make LDFLAGS=-all-static $PARALLEL
strip gettext-tools/src/{msgfmt,msgmerge,xgettext}
cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /usr/bin

# BISON

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/bison-3.8.2.tar.xz
cd bison-3.8.2
./configure --prefix=/usr \
            --docdir=/usr/share/doc/bison-3.8.2
make $PARALLEL
make install-strip

# PERL

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/perl-5.36.1.tar.xz
cd perl-5.36.1
sh Configure \
	-des -Dcc=gcc -A ldflags=-static -Dprefix=/usr -Dvendorprefix=/usr -Dusedevel '-Dlocinpth= ' -Duselargefiles -Dusethreads -Dd_semctl_semun -Dusenm -Ud_csh -Uusedl -Dinstallusrbinperl -Uversiononly
make $PARALLEL
make install-strip

# PYTHON

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/Python-3.11.2.tar.xz
cd Python-3.11.2
./configure --prefix=/usr   \
            --disable-shared \
            --enable-static \
            --enable-optimizations \
            --without-ensurepip
cp $HOME/python-setup.txt Modules/Setup
make LINKFORSHARED=" " $PARALLEL
make install
strip /usr/bin/python3.11

# TEXIFO

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/texinfo-7.0.2.tar.xz
cd texinfo-7.0.2
./configure --prefix=/usr
make $PARALLEL
make install-strip

# UTIL-LINUX

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/util-linux-2.38.1.tar.xz
cd util-linux-2.38.1
./configure \
            --libdir=/usr/lib    \
            --docdir=/usr/share/doc/util-linux-2.38.1 \
            --disable-chfn-chsh  \
            --disable-login      \
            --disable-nologin    \
            --disable-su         \
            --disable-setpriv    \
            --disable-runuser    \
            --disable-pylibmount \
            --disable-shared     \
            --enable-static      \
            --without-python     \
            runstatedir=/run
make LDFLAGS="-all-static" $PARALLEL
make install-strip

# CLEANUP

rm -rf /usr/share/{info,man,doc}
rm -f /lib/*.la
rm -rf /tools


