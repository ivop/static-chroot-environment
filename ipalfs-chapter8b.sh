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

# PKGCONFIG

cd $BUILD_PACKAGES
tar xvzf $PACKAGES/pkg-config-0.29.2.tar.gz
cd pkg-config-0.29.2
./configure --prefix=/usr              \
            --with-internal-glib       \
            --disable-host-tool        \
            --docdir=/usr/share/doc/pkg-config-0.29.2
make LDFLAGS=-all-static $PARALLEL
make install-strip

# NCURSES

cd $BUILD_PACKAGES
tar xvzf $PACKAGES/ncurses-6.4.tar.gz
cd ncurses-6.4
./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            --without-shared        \
            --without-debug         \
            --with-normal           \
            --with-cxx-normal       \
            --without-cxx-shared    \
            --enable-pc-files       \
            --enable-widec          \
            --with-pkg-config-libdir=/usr/lib/pkgconfig
make $PARALLEL
make install
rm -f /usr/lib/libncurses{,++}.a
ln -s libncursesw.a /usr/lib/libncurses.a
ln -s libncurses++w.a /usr/lib/libncurses++.a

# SED

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/sed-4.9.tar.xz
cd sed-4.9
./configure --prefix=/usr
make $PARALLEL
make install-strip

# PSMISC (no peekfd?)

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/psmisc-23.6.tar.xz
cd psmisc-23.6
./configure --prefix=/usr
make $PARALLEL
make install-strip

# GETTEXT

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/gettext-0.21.1.tar.xz
cd gettext-0.21.1
./configure --prefix=/usr    \
            --disable-shared \
            --docdir=/usr/share/doc/gettext-0.21.1
make LDFLAGS=-all-static $PARALLEL
make install-strip

# BISON

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/bison-3.8.2.tar.xz
cd bison-3.8.2
./configure --prefix=/usr \
            --docdir=/usr/share/doc/bison-3.8.2
make $PARALLEL
make install-strip

# GREP

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/grep-3.8.tar.xz
cd grep-3.8
sed -i "s/echo/#echo/" src/egrep.sh
./configure --prefix=/usr
make $PARALLEL
make install-strip

# LIBTOOL

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/libtool-2.4.7.tar.xz
cd libtool-2.4.7
./configure --prefix=/usr --disable-shared
make $PARALLEL
make install

# GDBM

cd $BUILD_PACKAGES
tar xvzf $PACKAGES/gdbm-1.23.tar.gz
cd gdbm-1.23
./configure --prefix=/usr --disable-shared --enable-libgdbm-compat
make LDFLAGS=-all-static $PARALLEL
make install-strip

# GPERF

cd $BUILD_PACKAGES
tar xvzf $PACKAGES/gperf-3.1.tar.gz
cd gperf-3.1
./configure --prefix=/usr --docdir=/usr/share/doc/gperf-3.1
make $PARALLEL
make install
strip /bin/gperf

#fi

if false; then

# BASH (postpone until we have autoconf)

cd $BUILD_PACKAGES
tar xvzf $PACKAGES/bash-5.2.15.tar.gz
cd bash-5.2.15
# patch inverted logic bug if we have strtoimax
sed -i 's/bash_cv_func_strtoimax = yes/bash_cv_func_strtoimax = no/' m4/strtoimax.m4
autoconf -f
./configure --prefix=/usr             \
            --without-bash-malloc     \
            --with-installed-readline \
            --enable-static-link      \
            --docdir=/usr/share/doc/bash-5.2.15
make $PARALLEL
make install-strip
rm -f /bin/sh
ln -sv bash /bin/sh

fi

# CLEANUP

rm -rf /usr/man /usr/share/man /usr/share/doc
rm -f /lib/*.{la,old}
