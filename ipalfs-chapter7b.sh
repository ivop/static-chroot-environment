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

#if false; then

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
	-des -Dcc=gcc -A ldflags=-static -Dprefix=/usr -Dvendorprefix=/usr -Dusedevel '-Dlocinpth= ' -Duselargefiles -Dusethreads -Dd_semctl_semun -Dusenm -Ud_csh -Uusedl -Dinstallusrbinperl
make $PARALLEL
make install-strip

#fi
