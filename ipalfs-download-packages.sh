#! /bin/bash

source ipalfs.env

PACKAGES=$LFS/packages

mkdir -pv $PACKAGES

cd $PACKAGES

for i in \
    https://github.com/slicer69/sysvinit/releases/download/3.06/sysvinit-3.06.tar.xz \
    https://www.infodrom.org/projects/sysklogd/download/sysklogd-1.5.1.tar.gz \
    https://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/v1.47.0/e2fsprogs-1.47.0.tar.gz \
    https://sourceforge.net/projects/procps-ng/files/Production/procps-ng-4.0.2.tar.xz \
    https://download.savannah.gnu.org/releases/man-db/man-db-2.11.2.tar.xz \
    https://github.com/eudev-project/eudev/releases/download/v3.2.11/eudev-3.2.11.tar.gz \
    https://anduin.linuxfromscratch.org/LFS/vim-9.0.1273.tar.xz \
    https://download.savannah.gnu.org/releases/libpipeline/libpipeline-1.5.7.tar.gz \
    https://www.kernel.org/pub/linux/utils/kbd/kbd-2.5.1.tar.xz \
    https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-6.1.0.tar.xz \
    https://ftp.gnu.org/gnu/grub/grub-2.06.tar.xz \
    https://ftp.gnu.org/gnu/groff/groff-1.22.4.tar.gz \
    https://github.com/libcheck/check/releases/download/0.15.2/check-0.15.2.tar.gz \
    https://github.com/mesonbuild/meson/releases/download/1.0.0/meson-1.0.0.tar.gz \
    https://github.com/ninja-build/ninja/archive/v1.11.1/ninja-1.11.1.tar.gz \
    https://pypi.org/packages/source/w/wheel/wheel-0.38.4.tar.gz \
    https://github.com/libffi/libffi/releases/download/v3.4.4/libffi-3.4.4.tar.gz \
    https://sourceware.org/ftp/elfutils/0.188/elfutils-0.188.tar.bz2 \
    https://www.kernel.org/pub/linux/utils/kernel/kmod/kmod-30.tar.xz \
    https://github.com/void-linux/musl-obstack/archive/refs/tags/v1.2.3.tar.gz \
    https://github.com/void-linux/musl-fts/archive/refs/tags/v1.2.7.tar.gz \
    https://github.com/ericonr/argp-standalone/archive/1.4.1.tar.gz \
    https://www.openssl.org/source/openssl-3.0.8.tar.gz \
    https://ftp.nluug.nl/gnu/automake/automake-1.16.5.tar.xz \
    https://ftp.nluug.nl/gnu/autoconf/autoconf-2.71.tar.xz \
    https://launchpad.net/intltool/trunk/0.51.0/+download/intltool-0.51.0.tar.gz \
    https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.46.tar.gz \
    https://www.greenwoodsoftware.com/less/less-608.tar.gz \
    https://ftp.nluug.nl/gnu/inetutils/inetutils-2.4.tar.xz \
    https://prdownloads.sourceforge.net/expat/expat-2.5.0.tar.xz \
    https://ftp.nluug.nl/gnu/gperf/gperf-3.1.tar.gz \
    https://ftp.nluug.nl/gnu/gdbm/gdbm-1.23.tar.gz \
    https://ftp.nluug.nl/gnu/libtool/libtool-2.4.7.tar.xz \
    https://sourceforge.net/projects/psmisc/files/psmisc/psmisc-23.6.tar.xz \
    https://pkg-config.freedesktop.org/releases/pkg-config-0.29.2.tar.gz \
    https://github.com/Mic92/iana-etc/releases/download/20230202/iana-etc-20230202.tar.gz \
    https://zlib.net/zlib-1.2.13.tar.xz \
    https://www.sourceware.org/pub/bzip2/bzip2-1.0.8.tar.gz \
    https://github.com/facebook/zstd/releases/download/v1.5.4/zstd-1.5.4.tar.gz \
    https://ftp.nluug.nl/gnu/readline/readline-8.2.tar.gz \
    https://github.com/gavinhoward/bc/releases/download/6.2.4/bc-6.2.4.tar.xz \
    https://github.com/westes/flex/releases/download/v2.6.4/flex-2.6.4.tar.gz \
    https://downloads.sourceforge.net/tcl/tcl8.6.13-src.tar.gz \
    https://prdownloads.sourceforge.net/expect/expect5.45.4.tar.gz \
    https://ftp.nluug.nl/gnu/dejagnu/dejagnu-1.6.3.tar.gz \
    https://ftp.nluug.nl/gnu/gmp/gmp-6.2.1.tar.xz \
    https://ftp.nluug.nl/gnu/mpfr/mpfr-4.2.0.tar.xz \
    https://ftp.nluug.nl/gnu/mpc/mpc-1.3.1.tar.gz \
    https://download.savannah.gnu.org/releases/attr/attr-2.5.1.tar.gz \
    https://download.savannah.gnu.org/releases/acl/acl-2.3.1.tar.xz \
    https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-2.67.tar.xz \
    https://github.com/shadow-maint/shadow/releases/download/4.13/shadow-4.13.tar.xz \
    https://www.kernel.org/pub/linux/utils/util-linux/v2.38/util-linux-2.38.1.tar.xz \
    https://ftp.nluug.nl/gnu/texinfo/texinfo-7.0.2.tar.xz \
    https://www.python.org/ftp/python/3.11.2/Python-3.11.2.tar.xz \
    https://www.cpan.org/src/5.0/perl-5.36.1.tar.xz \
    https://ftp.nluug.nl/gnu/bison/bison-3.8.2.tar.xz \
    https://ftp.nluug.nl/gnu/gettext/gettext-0.21.1.tar.xz \
    https://ftp.nluug.nl/gnu/binutils/binutils-2.40.tar.xz \
    https://ftp.nluug.nl/gnu/gcc/gcc-12.2.0/gcc-12.2.0.tar.xz \
    https://musl.libc.org/releases/musl-1.2.3.tar.gz \
    https://www.kernel.org/pub/linux/kernel/v6.x/linux-6.1.11.tar.xz \
    https://ftp.nluug.nl/gnu/m4/m4-1.4.19.tar.xz \
    https://ftp.nluug.nl/gnu/ncurses/ncurses-6.4.tar.gz \
    https://ftp.nluug.nl/gnu/bash/bash-5.2.15.tar.gz \
    https://ftp.nluug.nl/gnu/coreutils/coreutils-9.1.tar.xz \
    https://ftp.nluug.nl/gnu/diffutils/diffutils-3.9.tar.xz \
    https://astron.com/pub/file/file-5.44.tar.gz \
    https://ftp.nluug.nl/gnu/findutils/findutils-4.9.0.tar.xz \
    https://ftp.nluug.nl/gnu/gawk/gawk-5.2.0.tar.xz \
    https://ftp.nluug.nl/gnu/grep/grep-3.8.tar.xz \
    https://ftp.nluug.nl/gnu/gzip/gzip-1.12.tar.xz \
    https://ftp.nluug.nl/gnu/make/make-4.4.tar.gz \
    https://ftp.nluug.nl/gnu/patch/patch-2.7.6.tar.xz \
    https://ftp.nluug.nl/gnu/sed/sed-4.9.tar.xz \
    https://ftp.nluug.nl/gnu/tar/tar-1.34.tar.xz \
    https://tukaani.org/xz/xz-5.4.1.tar.xz \
     ; do
    wget --continue "$i"
done

echo "GETTING PACKAGES DONE"

