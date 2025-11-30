========================================
# bc-tool - A tool for unpacking/repacking LineageOS Android-14/15 images (aml_upgrade_package.img) for Amlogic TV-Boxes.

========================================
* Special thanks:

* anpaza - Android Firmware Construction Kit (afck), https://github.com/anpaza/afck

* a3sf6f - https://github.com/a3sf6f/sharp_s2_system_image/tree/master/bin, https://github.com/a3sf6f/sharp_s2_system_image/tree/master/test
  Scripts:
  - dump_android_filesystem.sh
  - generate_fs_config.sh
  - getcap_helper.pl
  - test_same_perms_caps_labels_stock80.sh

* LineageOS - https://github.com/LineageOS
  Pre-built binaries:
  - libselinux/utils -> sefcontext_compile
  - secilc -> secilc
  - e2fsprogs -> e2fsdroid, mke2fs
  - platform_tools -> lpdump, lpmake, lpunpack, lpadd
  - dtTool -> dtbTool
========================================

What is needed
----------------------------------------
- OS Ubuntu ≥ 20.04 / 64bit
- android-tools-fsutils
- device-tree-compiler (DTC)
- gawk
- brotli

---------------------------------------
- Install
---------------------------------------

- clone afck-Project

git clone https://github.com/bumerc77/afck.git

- Install packages

sudo apt install device-tree-compiler android-sdk-libsparse-utils android-sdk-ext4-utils gawk brotli

=========================================
# HOW TO USE #

copy aml_upgrade_package to the ~/afck/ingredients folder

cd ~/afck

# IMPORTANT: If you want to unpack an image (old format - system_as_root, gxl, gxm platform, kernel 4.9.113), please set the variable "TARGET_HAS_DYNAMIC_PART" to "false" in afck/local-config.mak, or do this in terminal:

export TARGET_HAS_DYNAMIC_PART=false

# By default - support for "dynamic partitions" is activated (new format for g12a, g12b, sm1, s4, t7, sc2 Platform, Kernel > 4.9.337, 5.4.xxx).

-----------------------------------------
- Call up list of available MOD's and description

make help-mod

or

make mod-help

-----------------------------------------
- unpack - always start with

# for new format img (dynamic partitions)
make mod-unpack-super

- or

# for system_as_root (old format img, pie)
make mod-unpack

-----------------------------------------
- Edit your partition/partitions and build them back into a sparse IMG
- Select and start the desired MOD, e.g.

# build all dynamic partitions + super.img
make mod-super

# if you have modified only a single dynamic partition, use:
make mod-system-dynamic
make mod-system_ext-dynamic
make mod-vendor-dynamic
make mod-vendor_dlkm-dynamic
make mod-product-dynamic
make mod-odm-dynamic

# System_as_root only - If you have made changes to several partitions at the same time, e.g. system, vendor, product etc., use:
make mod-partition-pie

# System_as_root only - If you have modified only a single partition, use:
make mod-system
make mod-vendor
make mod-odm

------------------------------------------
- Check the partitions for correct file and directory permissions, file contexts, capabilities..
# It is recommended to run this MOD after building the partitions. The mod-inspect compares stock and custom partitions and points out the differences

# for system_as_root
make mod-inspect-pie

# for dynamic partitions
make mod-inspect-dynamic

------------------------------------------
- Edit sepolicy
# If you have made changes to sepolicy *.cil files, you must recompile it

# for system_as_root
make mod-sepolicy-pie

# for dynamic partitions
make mod-sepolicy-dynamic

-----------------------------------------
- Build an installation IMG, aml_upgrade_package.img for UBT / sdc_burn

# new format img (super.img)
make mod-img-dynamic

# system_as_root (old fomat)
make mod-img-pie

-----------------------------------------
- resize partitions

# dynamic partitions + partition super
make mod-resize-super

# system_as_root
make mod-resize-pie

-----------------------------------------
- decompile single/multi dtb

make mod-dts

----------------------------------------
- compile single/multi dtb

make mod-dtb

----------------------------------------
- Cleanup bc-tool directory

make cleanup

# Options
1. cleanup build directory (all extracted/already modified files and folders in the bc-tool directory will be deleted).
If you want to run mod-super, mod-partition-pie or mod-<partition> repeatedly, there is no need to run option 1 as the build script will do it.
2. cleanup output directory only (Delete all files in bc-tool/out/ directory)
3. cleanup bc-tool/stamp/ directory (to be able to execute the same MODs repeatedly)

------------------------------------------
- Cleanup 'out/amlogic/device/lineage/img-unpack' directory

make clean

------------------------------------------
- Convert <lineage-*.zip> to <aml_upgrade_package.img>

# Define your *.zip package in local-config.mak, e.g
LINEAGE_ZIP = ingredients/lineage-22.2-20251130-nightly-m5-signed.zip

# Download lineage <aml_install_package>
# wget https://mirrorbits.lineageos.org/full/<device>/<build-date>/aml_install_package.img -P ingredients/
wget https://mirrorbits.lineageos.org/full/m5/20251130/aml_install_package.img -P ingredients/

# Download <lineage-*.zip>
# wget https://mirrorbits.lineageos.org/full/<device>/<build-date>/lineage-22.2-<build-date>-nightly-<device>-signed.zip -P ingredients/ | echo "<sha256-sum> ingredients/lineage-22.2-<build-date>-nightly-<device>-signed.zip" | sha256sum -c
wget https://mirrorbits.lineageos.org/full/m5/20251130/lineage-22.2-20251130-nightly-m5-signed.zip -P ingredients/ | echo "9028ed0c3b8869cc80eb280bf1a45677dcdeb12e0017b709dc22e7689479410b ingredients/lineage-22.2-20251130-nightly-m5-signed.zip" | sha256sum -c

# Extract <aml_install_package> and <lineage-*.zip>
make mod-extract-zip

# Building the super.img
make mod-super-only

# Build <aml_upgrade_package>
make mod-img-dynamic

# other info
------------------------------------------
# Build directory
bc-tool/build/<partition>

# Target directories (out)
out/amlogic/device/lineage/img-unpack/(extracted aml_package_upgrade.img files)
bc-tool/out/aml_upgrade_package.img

# old format, sparse partitions ##
bc-tool/out/system.PARTITION
bc-tool/out/vendor.PARTITION
## bc-tool/out/product.PARTITION (dropped and is now part of the system partition)
bc-tool/out/odm.PARTITION

# dynamic partitions, raw partitions ##
bc-tool/out/system.img
bc-tool/out/system_ext.img
bc-tool/out/vendor.img
bc-tool/out/vendor_dlkm.img
bc-tool/out/product.img
bc-tool/out/odm.img
bc-tool/odm/out/super.img (sparse)
bc-tool/stamp/.stamp.mod* files

# contexts files
bc-tool/build/selinux

# Generated fs_config files
bc-tool/out/<partition>_fs_config.ini

# dtb/dts
bc-tool/DTB
bc-tool/*.dtb
bc-tool/*.dts

# part_table - is a dtb file used to build dynamic partitions and resize them
bc-tool/part_table

------------------------------------------
# NOTE:
Generated timestamp files are used to protect against repeated overwriting of the files.
If you want to use a MOD repeatedly, you must delete the respective .stamp.mod* file in the bc-tool/stamp, but please note that the previously executed MOD will be overwritten (use "make cleanup" for this, see above)

------------------------------------------
# If you want to use your own project binary, just compile it e.g.:

~$ cd patch/to-your/sdk
~$ . build/envsetup.sh
~$ lunch your-device
~$ godir e2fsdroid
~$ mma

