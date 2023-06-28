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

# EXPAT

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/expat-2.5.0.tar.xz
cd expat-2.5.0
./configure --prefix=/usr --disable-shared --docdir=/usr/share/doc/expat-2.5.0
make LDFLAGS=-all-static $PARALLEL
make install-strip

# INETUTILS
# (proper /proc needs to be mounted to build)

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/inetutils-2.4.tar.xz
cd inetutils-2.4
./configure --prefix=/usr        \
            --bindir=/usr/bin    \
            --localstatedir=/var \
            --disable-logger     \
            --disable-rcp        \
            --disable-rexec      \
            --disable-rlogin     \
            --disable-rsh        \
            --disable-servers
make $PARALLEL
make install-strip
mv /bin/ifconfig /sbin/ifconfig

# LESS

cd $BUILD_PACKAGES
tar xvzf $PACKAGES/less-608.tar.gz
cd less-608
./configure --prefix=/usr --sysconfdir=/etc
make $PARALLEL
make install-strip

# PERL  (TODO: check cc="gcc -static" for previous PERL builds, it's better)

export BUILD_ZLIB=False
export BUILD_BZIP2=0
cd $BUILD_PACKAGES
tar xvJf $PACKAGES/perl-5.36.1.tar.xz
cd perl-5.36.1
sh Configure \
    -des -Dcc="gcc -static" -A ldflags=-static -Dprefix=/usr -Dvendorprefix=/usr -Dusedevel '-Dlocinpth= ' -Duselargefiles -Dusethreads -Dd_semctl_semun -Dusenm -Ud_csh -Uusedl -Dinstallusrbinperl -Uversiononly -Dpager="/usr/bin/less -isR"
make $PARALLEL
make install-strip
unset BUILD_ZLIB BUILD_BZIP2

cd $BUILD_PACKAGES
tar xvzf $PACKAGES/XML-Parser-2.46.tar.gz
cd XML-Parser-2.46
perl Makefile.PL
make perl
make install
make -f Makefile.aperl inst_perl MAP_TARGET=perl
make -f Makefile.aperl map_clean

# INTLTOOL

cd $BUILD_PACKAGES
tar xvzf $PACKAGES/intltool-0.51.0.tar.gz
cd intltool-0.51.0
sed -i 's:\\\${:\\\$\\{:' intltool-update.in
./configure --prefix=/usr
make $PARALLEL
make install-strip

# AUTOCONF

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/autoconf-2.71.tar.xz
cd autoconf-2.71
./configure --prefix=/usr
make $PARALLEL
make install

# BASH (postponed until we have autoconf)

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

# AUTOMAKE

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/automake-1.16.5.tar.xz
cd automake-1.16.5
./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.16.5
make $PARALLEL
make install

# OPENSSL

cd $BUILD_PACKAGES
tar xvzf $PACKAGES/openssl-3.0.8.tar.gz
cd openssl-3.0.8
./Configure --prefix=/usr         \
         --openssldir=/etc/ssl \
         --libdir=lib          \
         -static               \
         no-shared             \
         zlib
sed -i 's/debugcolor//' providers/common/der/oids_to_c.pm
make $PARALLEL
make install_sw install_ssldirs
strip /bin/openssl

# KMOD

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/kmod-30.tar.xz
cd kmod-30
./configure --prefix=/usr          \
            --sysconfdir=/etc      \
            --with-openssl         \
            --with-xz              \
            --with-zstd            \
            --with-zlib
make LDFLAGS=-all-static $PARALLEL
make install-strip
for target in depmod insmod modinfo modprobe rmmod; do
  ln -sfv ../bin/kmod /usr/sbin/$target
done
ln -sfv kmod /usr/bin/lsmod

# ARGP STANDALONE (non-LFS but we need it because we don't have glibc)

cd $BUILD_PACKAGES
tar xvzf $PACKAGES/1.4.1.tar.gz
cd argp-standalone-1.4.1
libtoolize --force
aclocal
autoheader
automake --force-missing --add-missing
autoupdate
autoconf
./configure --prefix=/usr
make $PARALLEL
cp libargp.a /lib
cp argp.h /usr/include

# MUSL FTS (non-LFS)

cd $BUILD_PACKAGES
tar xvzf $PACKAGES/v1.2.7.tar.gz
cd musl-fts-1.2.7
libtoolize --force
aclocal
autoheader
automake --force-missing --add-missing
autoupdate
autoconf
./configure --prefix=/usr
make $PARALLEL
make install

# MUSL OBSTACK (non-LFS)

cd $BUILD_PACKAGES
tar xvzf $PACKAGES/v1.2.3.tar.gz
cd musl-obstack-1.2.3
libtoolize --force
aclocal
autoheader
automake --force-missing --add-missing
autoupdate
autoconf
./configure --prefix=/usr
make $PARALLEL
make install

# LIBELF

cd $BUILD_PACKAGES
tar xvjf $PACKAGES/elfutils-0.188.tar.bz2
cd elfutils-0.188
sed -i 's/dso_LDFLAGS="-shared"//' configure
./configure --prefix=/usr                \
            --disable-debuginfod         \
            --disable-shared             \
            --enable-libdebuginfod=dummy
make $PARALLEL -C libelf libelf.a
make -C libelf install-libLIBRARIES install-includeHEADERS install-pkgincludeHEADERS
install -vm644 config/libelf.pc /usr/lib/pkgconfig

cd $BUILD_PACKAGES
tar xvzf $PACKAGES/libffi-3.4.4.tar.gz
cd libffi-3.4.4
./configure --prefix=/usr          \
            --disable-shared
make $PARALLEL
make install

#fi

# CLEANUP

rm -rf /usr/man /usr/share/man /usr/share/doc
rm -f /lib/*.{la,old}
