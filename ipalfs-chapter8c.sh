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

#fi

# CLEANUP

rm -rf /usr/man /usr/share/man /usr/share/doc
rm -f /lib/*.{la,old}
