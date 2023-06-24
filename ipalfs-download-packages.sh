#! /bin/bash

source ipalfs.env

PACKAGES=$LFS/packages

mkdir -pv $PACKAGES

cd $PACKAGES

for i in \
    https://www.kernel.org/pub/linux/utils/util-linux/v2.38/util-linux-2.38.1.tar.xz \
    https://ftp.nluug.nl/gnu/texinfo/texinfo-7.0.2.tar.xz \
    https://www.python.org/ftp/python/3.11.2/Python-3.11.2.tar.xz \
    https://www.cpan.org/src/5.0/perl-5.36.0.tar.xz \
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

