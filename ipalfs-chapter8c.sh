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

# PYTHON

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/Python-3.11.2.tar.xz
cd Python-3.11.2
./configure --prefix=/usr        \
            --disable-shared     \
            --enable-static      \
            --with-system-expat  \
            --with-system-ffi    \
            --enable-optimizations
cp $HOME/python-setup2.txt Modules/Setup
make LINKFORSHARED=" " CFLAGS=-DOPENSSL_THREADS $PARALLEL
make install
strip /usr/bin/python3.11

#fi

# CLEANUP

rm -rf /usr/man /usr/share/man /usr/share/doc
rm -f /lib/*.{la,old}
