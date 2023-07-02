#! /bin/bash

source ipalfs.env

PACKAGES=packages

mkdir -pv $PACKAGES

cd $PACKAGES

for i in \
    https://dri.freedesktop.org/libdrm/libdrm-2.4.115.tar.xz \
    https://www.x.org/pub/individual/data/xbitmaps-1.1.2.tar.bz2 \
    https://www.x.org/pub/individual/lib/libxcvt-0.1.2.tar.xz \
    https://xcb.freedesktop.org/dist/xcb-util-0.4.1.tar.xz \
    https://xcb.freedesktop.org/dist/xcb-util-image-0.4.1.tar.xz \
    https://xcb.freedesktop.org/dist/xcb-util-keysyms-0.4.1.tar.xz \
    https://xcb.freedesktop.org/dist/xcb-util-renderutil-0.3.10.tar.xz \
    https://xcb.freedesktop.org/dist/xcb-util-wm-0.4.2.tar.xz \
    https://xcb.freedesktop.org/dist/xcb-util-cursor-0.1.4.tar.xz \
    https://mesa.freedesktop.org/archive/mesa-22.3.5.tar.xz \
    https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.14.2.tar.xz \
    https://downloads.sourceforge.net/freetype/freetype-2.13.0.tar.xz \
    https://www.x.org/pub/individual/util/util-macros-1.20.0.tar.xz \
    https://xorg.freedesktop.org/archive/individual/proto/xorgproto-2022.2.tar.xz \
    https://www.x.org/pub/individual/lib/libXau-1.0.11.tar.xz \
    https://www.x.org/pub/individual/lib/libXdmcp-1.1.4.tar.xz \
    https://xorg.freedesktop.org/archive/individual/proto/xcb-proto-1.15.2.tar.xz \
    https://xorg.freedesktop.org/archive/individual/lib/libxcb-1.15.tar.xz \
     ; do
    wget --continue "$i"
done

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
    wget --continue https://www.x.org/pub/individual/lib/$i
done

echo "GETTING PACKAGES DONE"

