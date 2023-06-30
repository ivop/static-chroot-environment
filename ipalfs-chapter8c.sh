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

#fi

# CLEANUP

rm -rf /usr/man /usr/share/man /usr/share/doc
rm -f /lib/*.{la,old}
