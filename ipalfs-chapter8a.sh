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

# IANA ETC

cd $BUILD_PACKAGES
tar xvzf $PACKAGES/iana-etc-20230202.tar.gz
cd iana-etc-20230202
cp services protocols /etc

# No need to recompile libc, which is musl and not glibc

# USE export TZ=`cat /etc/timezone` in .profile
# This is CE(S)T, i.e. Amsterdam, Brussels, Berlin, etc...

echo "CET-1CEST,M3.5.0,M10.5.0/3" > /etc/timezone

# ZLIB

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/zlib-1.2.13.tar.xz
cd zlib-1.2.13
./configure --prefix=/usr --static
make $PARALLEL
make install

# BZIP2

cd $BUILD_PACKAGES
tar xvzf $PACKAGES/bzip2-1.0.8.tar.gz
cd bzip2-1.0.8
make install PREFIX=/usr LDFLAGS=-static
strip /bin/{bzcat,bzip2,bzip2recover}

#fi

# XZ

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/xz-5.4.1.tar.xz
cd xz-5.4.1
./configure --prefix=/usr    \
            --disable-shared \
            --docdir=/usr/share/doc/xz-5.4.1
make LDFLAGS=-all-static $PARALLEL
make install-strip



# CLEANUP

rm -rf /usr/man /usr/share/man /usr/share/doc
