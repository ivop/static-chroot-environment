# static-chroot-environment

Build a fully static chroot environment based on LFS and musl.  

### Instructions

* Follow LFS up to chapter 4. Create lfs user and group.
* As user lfs, checkout this repo and run the scripts.
* ipalfs-download-packages.sh to retrieve the needed packages.
* ipalfs-chapter5.sh automates chapter 5.
* ipalfs-chapter6a and 6b automate chapter 6.
* You now have a chrootable directory lfs without shared libraries or dynamically linked binaries.

