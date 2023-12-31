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

# WHEEL (needs ctypes, and there's a ton of macosx drivel)
#
#cd $BUILD_PACKAGES
#tar xvzf $PACKAGES/wheel-0.38.4.tar.gz
#cd wheel-0.38.4
#PYTHONPATH=src pip3 wheel -w dist --no-build-isolation --no-deps $PWD
#
# forget about WHEEL for now, we don't need it anyway

# NINJA

cd $BUILD_PACKAGES
tar xvzf $PACKAGES/ninja-1.11.1.tar.gz
cd ninja-1.11.1
python3 configure.py --bootstrap
strip ninja
install -vm755 ninja /usr/bin/
install -vDm644 misc/bash-completion /usr/share/bash-completion/completions/ninja
install -vDm644 misc/zsh-completion  /usr/share/zsh/site-functions/_ninja

# MESON
#
#cd $BUILD_PACKAGES
#tar xvzf $PACKAGES/meson-1.0.0.tar.gz
#cd meson-1.0.0
#
# we need bdist_wheel for this, skip! Never seen meson as a build tool anyway

# COREUTILS

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/coreutils-9.1.tar.xz
cd coreutils-9.1
patch -Np1 -i $HOME/coreutils-9.1-i18n-1.patch
autoreconf -fiv
FORCE_UNSAFE_CONFIGURE=1 ./configure \
            --prefix=/usr            \
            --enable-no-install-program=kill,uptime
make $PARALLEL
make install-strip
mv -v /usr/bin/chroot /usr/sbin

# CHECK

cd $BUILD_PACKAGES
tar xvzf $PACKAGES/check-0.15.2.tar.gz
cd check-0.15.2
./configure --prefix=/usr --disable-shared
make $PARALLEL
make install

# DIFFUTILS

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/diffutils-3.9.tar.xz
cd diffutils-3.9
./configure --prefix=/usr
make $PARALLEL
make install-strip

# GAWK

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/gawk-5.2.0.tar.xz
cd gawk-5.2.0
sed -i 's/extras//' Makefile.in
./configure --prefix=/usr
make $PARALLEL
make LN='ln -f' install-strip

# FINDUTILS

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/findutils-4.9.0.tar.xz
cd findutils-4.9.0
./configure --prefix=/usr                   \
            --localstatedir=/var/lib/locate
make $PARALLEL
make install-strip

# GROFF

cd $BUILD_PACKAGES
tar xvzf $PACKAGES/groff-1.22.4.tar.gz
cd groff-1.22.4
PAGE=A4 ./configure --prefix=/usr
make $PARALLEL
make install-strip

# GRUB

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/grub-2.06.tar.xz
cd grub-2.06
patch -Np1 -i $HOME/grub-2.06-upstream_fixes-1.patch
./configure --prefix=/usr --sysconfdir=/etc --disable-efiemu --disable-werror \
        BUILD_LDFLAGS=-static --with-platform=efi --target=x86_64
sed -i 's/BUILD_SIZEOF_LONG/BUILD_SIZEOF_LONG 8/' config.h
sed -i 's/BUILD_SIZEOF_VOID_P/BUILD_SIZEOF_VOID_P 8/' config.h
make $PARALLEL
make install-strip
mv -v /etc/bash_completion.d/grub /usr/share/bash-completion/completions

# GZIP

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/gzip-1.12.tar.xz
cd gzip-1.12
./configure --prefix=/usr
make $PARALLEL
make install-strip

# IPROUTE2

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/iproute2-6.1.0.tar.xz
cd iproute2-6.1.0
sed -i /ARPD/d Makefile
rm -fv man/man8/arpd.8
make NETNS_RUN_DIR=/run/netns LDFLAGS="-static -lelf -lz" CC="gcc -static" \
        $PARALLEL V=1
make SBINDIR=/usr/sbin install
strip /sbin/{bridge,genl,ifstat,ip,lnstat,nstat,rtacct,rtmon,ss,tc}

# KBD

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/kbd-2.5.1.tar.xz
cd kbd-2.5.1
sed -i '/RESIZECONS_PROGS=/s/yes/no/' configure
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in
./configure --prefix=/usr --disable-vlock
make LDFLAGS=-all-static $PARALLEL
make install-strip

# LIBPIPELINE

cd $BUILD_PACKAGES
tar xvzf $PACKAGES/libpipeline-1.5.7.tar.gz
cd libpipeline-1.5.7
./configure --prefix=/usr --disable-shared
make $PARALLEL
make install

# MAKE

cd $BUILD_PACKAGES
tar xvzf $PACKAGES/make-4.4.tar.gz
cd make-4.4
sed -e '/ifdef SIGPIPE/,+2 d' \
    -e '/undef  FATAL_SIG/i FATAL_SIG (SIGPIPE);' \
    -i src/main.c
./configure --prefix=/usr
make $PARALLEL
make install-strip

# PATCH

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/patch-2.7.6.tar.xz
cd patch-2.7.6
./configure --prefix=/usr
make $PARALLEL
make install-strip

# TAR

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/tar-1.34.tar.xz
cd tar-1.34
FORCE_UNSAFE_CONFIGURE=1 ./configure --prefix=/usr
make $PARALLEL
make install-strip

# TEXINFO

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/texinfo-7.0.2.tar.xz
cd texinfo-7.0.2
./configure --prefix=/usr
make $PARALLEL
make install-strip

# VIM

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/vim-9.0.1273.tar.xz
cd vim-9.0.1273
echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h
./configure --prefix=/usr
make $PARALLEL
make install
ln -s vim /usr/bin/vi

# EUDEV (this libtool and forked of systemd mess doesn't play well with static
#        linking; won't waste more time on it as I don't need it)
#
#cd $BUILD_PACKAGES
#tar xvzf $PACKAGES/eudev-3.2.11.tar.gz
#cd eudev-3.2.11
#sed -i '/udevdir/a udev_dir=${udevdir}' src/udev/udev.pc.in
#./configure --prefix=/usr           \
#            --bindir=/usr/sbin      \
#            --sysconfdir=/etc       \
#            --disable-manpages      \
#            --disable-shared
#make LDFLAGS="-all-static" $PARALLEL V=1
#mkdir -pv /usr/lib/udev/rules.d
#mkdir -pv /etc/udev/rules.d
#make install-strip

# MAN-DB

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/man-db-2.11.2.tar.xz
cd man-db-2.11.2
./configure --prefix=/usr                         \
            --docdir=/usr/share/doc/man-db-2.11.2 \
            --sysconfdir=/etc                     \
            --disable-setuid                      \
            --enable-cache-owner=bin              \
            --with-browser=/usr/bin/lynx          \
            --with-vgrind=/usr/bin/vgrind         \
            --with-grap=/usr/bin/grap             \
            --with-systemdtmpfilesdir=            \
            --with-systemdsystemunitdir=
make LDFLAGS=-all-static $PARALLEL
make install-strip

# PROCPS-NG

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/procps-ng-4.0.2.tar.xz
cd procps-ng-4.0.2
./configure --prefix=/usr                           \
            --docdir=/usr/share/doc/procps-ng-4.0.2 \
            --disable-shared                        \
            --disable-w                             \
            --disable-kill
make LDFLAGS=-all-static $PARALLEL
make install-strip

# UTIL-LINUX

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/util-linux-2.38.1.tar.xz
cd util-linux-2.38.1
./configure ADJTIME_PATH=/var/lib/hwclock/adjtime \
            --bindir=/usr/bin    \
            --libdir=/usr/lib    \
            --sbindir=/usr/sbin  \
            --disable-chfn-chsh  \
            --disable-login      \
            --disable-nologin    \
            --disable-su         \
            --disable-setpriv    \
            --disable-runuser    \
            --disable-pylibmount \
            --disable-shared     \
            --without-python     \
            --without-systemd    \
            --without-systemdsystemunitdir \
            --docdir=/usr/share/doc/util-linux-2.38.1
make LDFLAGS="-all-static" $PARALLEL
make install-strip

# E2FSPROGS

cd $BUILD_PACKAGES
tar xvzf $PACKAGES/e2fsprogs-1.47.0.tar.gz
cd e2fsprogs-1.47.0
mkdir build
cd build
../configure --prefix=/usr           \
             --sysconfdir=/etc       \
             --disable-libblkid      \
             --disable-libuuid       \
             --disable-uuidd         \
             --disable-fsck
make $PARALLEL
make install-strip
strip /bin/{ch,ls}attr

# SYSKLOGD is crap and doesn't build with a modern standards compliant musl
#
#cd $BUILD_PACKAGES
#tar xvzf $PACKAGES/sysklogd-1.5.1.tar.gz
#cd sysklogd-1.5.1
##sed -i '/Error loading kernel symbols/{n;n;d}' ksym_mod.c
##sed -i 's/union wait/int/' syslogd.c
#make $PARALLEL
#make BINDIR=/sbin install

# SYSVINIT

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/sysvinit-3.06.tar.xz
cd sysvinit-3.06
patch -Np1 -i $HOME/sysvinit-3.06-consolidated-1.patch
make $PARALLEL
make install
strip /sbin/{bootlogd,fstab-decode,halt,init,killall5,runlevel,shutdown}

#fi

# CLEANUP

rm -rf /usr/man /usr/share/man /usr/share/doc
rm -f /lib/*.{la,old}
