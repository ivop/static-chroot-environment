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
strip /bin/{bzcat,bzip2,bzip2recover,bunzip2}

# XZ

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/xz-5.4.1.tar.xz
cd xz-5.4.1
./configure --prefix=/usr    \
            --disable-shared \
            --docdir=/usr/share/doc/xz-5.4.1
make LDFLAGS=-all-static $PARALLEL
make install-strip

# ZSTD

cd $BUILD_PACKAGES
tar xvzf $PACKAGES/zstd-1.5.4.tar.gz
cd zstd-1.5.4
cd lib
make LDFLAGS=-static prefix=/usr $PARALLEL install-static install-pc install-includes
cd ../programs
make LDFLAGS=-static prefix=/usr $PARALLEL install
strip /bin/zstd

# FILE

cd $BUILD_PACKAGES
tar xvzf $PACKAGES/file-5.44.tar.gz
cd file-5.44
./configure --prefix=/usr --disable-shared --enable-static
make LDFLAGS=-all-static $PARALLEL
make install-strip

# READLINE

cd $BUILD_PACKAGES
tar xvzf $PACKAGES/readline-8.2.tar.gz
cd readline-8.2
patch -Np1 -i $HOME/readline-8.2-upstream_fix-1.patch
./configure --prefix=/usr --enable-static --disable-shared --with-curses \
		--docdir=/usr/share/doc/readline-8.2
make $PARALLEL
make install

# M4

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/m4-1.4.19.tar.xz
cd m4-1.4.19
./configure --prefix=/usr
make $PARALLEL
make install-strip

# BC

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/bc-6.2.4.tar.xz
cd bc-6.2.4
CC=gcc ./configure --prefix=/usr -G -O3 -r
gcc -static -DBC_ENABLE_AFL=0 -I./include/   -o ./gen/strgen ./gen/strgen.c
make $PARALLEL LDFLAGS="-static -lreadline -lncurses"
make install
strip /bin/{bc,dc}

# FLEX

cd $BUILD_PACKAGES
tar xvzf $PACKAGES/flex-2.6.4.tar.gz
cd flex-2.6.4
./configure --prefix=/usr --docdir=/usr/share/doc/flex-2.6.4 --disable-shared
make $PARALLEL LDFLAGS=-all-static
make install-strip
ln -sv flex /usr/bin/lex

# TCL

cd $BUILD_PACKAGES
tar xvzf $PACKAGES/tcl8.6.13-src.tar.gz
cd tcl8.6.13/unix
./configure --enable-threads --disable-load --enable-shared=no \
	--disable-symbols --enable-64bit --enable-static --disable-shared \
	--prefix=/usr
rm -rf ../pkgs/*  # skip non-core which is broken and keeps doing -shared
make $PARALLEL
make install-strip
make install-private-headers
rm -f /usr/bin/tclsh
ln -sv tclsh8.6 /usr/bin/tclsh

# EXPECT (note: we need /dev and /proc mounted)

cd $BUILD_PACKAGES
tar xvzf $PACKAGES/expect5.45.4.tar.gz
cd expect5.45.4
./configure --prefix=/usr           \
            --with-tcl=/usr/lib     \
            --disable-shared        \
            --mandir=/usr/share/man \
            --with-tclinclude=/usr/include
sed -i 's/-ltcl8.6/-ltcl8.6 -ltclstub8.6 -lz/' Makefile
make $PARALLEL
make install
rm -f /usr/lib/libexpect5.45.4.a
ln -svf expect5.45.4/libexpect5.45.4.a /usr/lib
strip /bin/expect

# DEJAGNU

cd $BUILD_PACKAGES
tar xvzf $PACKAGES/dejagnu-1.6.3.tar.gz
cd dejagnu-1.6.3
mkdir build
cd build
../configure --prefix=/usr
make $PARALLEL
make install

#fi

# CLEANUP

rm -rf /usr/man /usr/share/man /usr/share/doc
rm -f /lib/*.{la,old}
