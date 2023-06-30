# static-chroot-environment

Static Linux From Scratch with musl.  

Build a fully static chroot environment based on LFS and musl.  

Target is amd64/x86_64.  

### Instructions

* Follow LFS up to chapter 4. Create lfs user and group.
* As user lfs, checkout this repo and run the scripts.
* Run ipalfs-download-packages.sh to retrieve the needed packages.
* Optionally you can create a tarball of the lfs directory after each build step.
* ipalfs-chapter5.sh automates chapter 5.
* ipalfs-chapter6a and 6b automate chapter 6.
* You now have a chrootable directory lfs without shared libraries or dynamically linked binaries.
* The tools directory can be deleted.
* From now on you can follow the LFS instructions and change ownership, add dev, proc, etc, passwd file, and so on. Note that some later steps need /proc and possibly /dev and /sys.
  
* Copy chapter7 and chapter8 files, all patches and both python-setup.txt to $LFS/root
* As root, run: ``chroot /home/lfs/lfs env -i HOME=/root PATH=/sbin:/bin TERM=ansi PS1='[(chroot) \u \w]# ' /bin/bash --login``
* Run ipalfs-chapter7a which creates some files we need
* ipalfs-chapter7b compiles the last temporary libraries and tools
* Leave chroot and make a backup of the roofs
  
* Enter chroot again (note: we need /proc and /dev mounted for expect and inetutils to work and/or build correctly)
* Run ipalfs-chapter8a to start building the actual chroot environment
* Continue with chapter8b and 8c
* This concludes the basic chroot. The contents of /root and /packages can be
deleted. All files in /bin and /sbin should be stripped and /lib contains
only static libraries.
* Make a backup tarball of the rootfs before you continue
* Note that ksyslogd, eudev (systemd fork libtool abomination), Meson and
Wheel are missing. I don't need them. YMMV.
* All documentation is either not installed or removed.
* Add ``export TZ=$(cat /etc/timezone)`` to /root/.profile for correct time
and date. Defaults to Europe/Amsterdam.
  
### Build times on AMD FX-8320 octacore 3.5GHz

* chapter5: 17m17.809s
* chapter6a: 9m20.996s
* chapter6b: 18m44.842s
* chapter7a: 0m0.218s
* chapter7b: 16m7.881s
* chapter8a: 24m42.194s 
* chapter8b: 15m43.402s
* chapter8c: 21m25.474s

Total: circa 123m16s, just over two hours.  

