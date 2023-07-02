#! /bin/bash

source ipablfs-xorg7.env

PARALLEL=-j8

PACKAGES=/root/packages
BUILD_PACKAGES=/root/build

rm -rf $BUILD_PACKAGES
mkdir -pv $BUILD_PACKAGES

export LDFLAGS=-static

#if false; then

# UTIL_MACROS

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/util-macros-1.20.0.tar.xz
cd util-macros-1.20.0
./configure $XORG_CONFIG
make $PARALLEL
make install

# XORGPROTO

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/xorgproto-2022.2.tar.xz
cd xorgproto-2022.2
mkdir build
cd build
../configure --prefix=$XORG_PREFIX --enable-legacy
make $PARALLEL
make install

# LIBXAU

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/libXau-1.0.11.tar.xz
cd libXau-1.0.11
./configure $XORG_CONFIG
make $PARALLEL
make install

# LIBXDMCP

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/libXdmcp-1.1.4.tar.xz
cd libXdmcp-1.1.4
./configure $XORG_CONFIG --docdir=/usr/share/doc/libXdmcp-1.1.4
make $PARALLEL
make install

# XCB-PROTO

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/xcb-proto-1.15.2.tar.xz
cd xcb-proto-1.15.2
PYTHON=python3 ./configure $XORG_CONFIG
make $PARALLEL
make install

# LIBXCB

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/libxcb-1.15.tar.xz
cd libxcb-1.15
PYTHON=python3                \
./configure $XORG_CONFIG      \
            --without-doxygen \
            --docdir='${datadir}'/doc/libxcb-1.15
make $PARALLEL
make install

# FREETYPE

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/freetype-2.13.0.tar.xz
cd freetype-2.13.0
sed -ri "s:.*(AUX_MODULES.*valid):\1:" modules.cfg
sed -r "s:.*(#.*SUBPIXEL_RENDERING) .*:\1:" \
    -i include/freetype/config/ftoption.h
./configure --prefix=/usr --enable-freetype-config --disable-shared
make CCexe="gcc -static" LDFLAGS=-all-static $PARALLEL
make install

# FONTCONFIG

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/fontconfig-2.14.2.tar.xz
cd fontconfig-2.14.2
./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --disable-docs       \
            --docdir=/usr/share/doc/fontconfig-2.14.2
make LDFLAGS=-all-static $PARALLEL
make install-strip

for i in \
    xtrans-1.4.0.tar.bz2 \
    libX11-1.8.4.tar.xz \
    libXext-1.3.5.tar.xz \
    libFS-1.0.9.tar.xz \
    libICE-1.1.1.tar.xz \
    libSM-1.2.4.tar.xz \
    libXScrnSaver-1.2.4.tar.xz \
    libXt-1.2.1.tar.bz2 \
    libXmu-1.1.4.tar.xz \
    libXpm-3.5.15.tar.xz \
    libXaw-1.0.14.tar.bz2 \
    libXfixes-6.0.0.tar.bz2 \
    libXcomposite-0.4.6.tar.xz \
    libXrender-0.9.11.tar.xz \
    libXcursor-1.2.1.tar.xz \
    libXdamage-1.1.6.tar.xz \
    libfontenc-1.1.7.tar.xz \
    libXfont2-2.0.6.tar.xz \
    libXft-2.3.7.tar.xz \
    libXi-1.8.tar.bz2 \
    libXinerama-1.1.5.tar.xz \
    libXrandr-1.5.3.tar.xz \
    libXres-1.2.2.tar.xz \
    libXtst-1.2.4.tar.xz \
    libXv-1.0.12.tar.xz \
    libXvMC-1.0.13.tar.xz \
    libXxf86dga-1.1.6.tar.xz \
    libXxf86vm-1.1.5.tar.xz \
    libdmx-1.1.4.tar.bz2 \
    libpciaccess-0.17.tar.xz \
    libxkbfile-1.1.2.tar.xz \
    libxshmfence-1.3.2.tar.xz \
     ; do

    cd $BUILD_PACKAGES
    tar xvf $PACKAGES/$i
    case $i in
        *.tar.bz2) j=`basename $i .tar.bz2` ;;
        *)         j=`basename $i .tar.xz` ;;
    esac
    cd $j

    DIFFERENT_LDFLAGS=""

    docdir="--docdir=$XORG_PREFIX/share/doc/$packagedir"
    case $j in
    libXfont2-[0-9]* )
      ./configure $XORG_CONFIG $docdir --disable-devel-docs
    ;;

    libXt-[0-9]* )
      ./configure $XORG_CONFIG $docdir \
                  --with-appdefaultdir=/etc/X11/app-defaults
      DIFFERENT_LDFLAGS="LDFLAGS=-all-static"
    ;;

    libXpm-[0-9]* )
      sed -i '/TestAll.*TRUE/s|^|//|' test/TestAllFiles.h
      ./configure $XORG_CONFIG $docdir --disable-open-zfile LIBS="-lSM -lICE -lxcb -lXau -lXdmcp"   # fix broken static linking
      DIFFERENT_LDFLAGS="LDFLAGS=-all-static"
    ;;
    
    * )
      ./configure $XORG_CONFIG $docdir
    ;;
    esac
    make $PARALLEL $DIFFERENT_LDFLAGS V=1 
    make install-strip
done

# LIBXCVT
# we don't have meson, but it's easy to build

cd $BUILD_PACKAGES
tar xvJf $PACKAGES/libxcvt-0.1.2.tar.xz
cd libxcvt-0.1.2
cd lib
gcc -O3 -I../include -c -o libxcvt.o libxcvt.c
ar rcs libxcvt.a libxcvt.o
ranlib libxcvt.a
cd ../cvt
gcc -static -I../include -ocvt cvt.c ../lib/libxcvt.a
cd ..
cp lib/libxcvt.a /lib
cp cvt/cvt /bin

# XCB-UTIL-* (order matters)

for i in \
    xcb-util-0.4.1.tar.xz \
    xcb-util-image-0.4.1.tar.xz \
    xcb-util-keysyms-0.4.1.tar.xz \
    xcb-util-renderutil-0.3.10.tar.xz \
    xcb-util-wm-0.4.2.tar.xz \
    xcb-util-cursor-0.1.4.tar.xz \
     ; do

    cd $BUILD_PACKAGES
    tar xvJf $PACKAGES/$i
    j=`basename $i .tar.xz`
    cd $j
    ./configure $XORG_CONFIG LIBS="-lXau -lXdmcp"
    make $PARALLEL
    make install
done

#fi

# CLEANUP

rm -rf /usr/man /usr/share/man /usr/share/doc
rm -f /lib/*.{la,old}

