# static-chroot-environment

Build a fully static chroot environment based on LFS and musl.  

### Instructions

* Follow LFS up to chapter 4. Create lfs user and group.
* As user lfs, checkout this repo and run the scripts.
* ipalfs-download-packages.sh to retrieve the needed packages.
* Optionally you can create a tarball of the lfs directory after each build step.
* ipalfs-chapter5.sh automates chapter 5.
* ipalfs-chapter6a and 6b automate chapter 6.
* You now have a chrootable directory lfs without shared libraries or dynamically linked binaries.
* The tools directory can be deleted.
* From now on you can follow the LFS instructions and change ownership, add dev, proc, etc, passwd file, and so on, or treat it solely as a contained build environment as we will do here.

* copy chapter7 files to $LFS/root
* As root, run: ``chroot /home/lfs/lfs env -i HOME=/root PATH=/sbin:/bin TERM=ansi PS1='[(chroot) \u \w]# ' /bin/bash --login``
* ipalfs-chapter7a creates some files we need
* ipalfs-chapter7b compiles the last temporary libraries and tools
* leave chroot and make a backup of the roofs

* copy chapter8 files, python-setup.txt and readline patch to $LFS/root and
enter chroot again
* run ipalfs-chapter8a to start building the actual chroot environment

### Build times on octacore 3.5GHz amd64

* chapter5: 17m17.809s
* chapter6a: 9m20.996s
* chapter6b: 18m44.842s
* chapter7a: 0m0.218s
* chapter7b: 16m7.881s
