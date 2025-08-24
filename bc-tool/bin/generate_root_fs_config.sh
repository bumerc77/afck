#!/bin/sh
#
# Generate Android filesystem information for system partition
#
if [ $# -lt 1 ]; then
    echo "Usage: $0 SYSTEM_DIR"
fi

SYSTEM_DIR=$1

# Generate wildcard default permissions:
# https://android.googlesource.com/platform/system/core/+/refs/tags/android-vts-15.0_r5/libcutils/fs_config.cpp
# https://android.googlesource.com/platform/system/core/+/refs/tags/android-vts-15.0_r5/libcutils/include/private/android_filesystem_config.h

cd build

{ \
    find $SYSTEM_DIR -type d -printf "%P 0 0 0755\n"; \
    find $SYSTEM_DIR -not -type d -printf "%P 0 0 0644\n"; \
} | sed -r "
    # initrd

    s|^(cache) .*|\1 1000 2001 0770|
    s|^(data) .*|\1 1000 1000 0771|
    s|^(apex) .*|\1 0 0 0755|
    s|^(mnt) .*|\1 0 1000 0755|
    s|^(sbin) .*|\1 0 2000 0750|
    s|^(sdcard) .*|\1 0 0 0644|
    s|^(storage) .*|\1 0 1028 0751|
    s|^(system/bin) .*|\1 0 2000 0751|
    s|^(system/etc/ppp) .*|\1 0 0 0755|
    s|^(system/xbin) .*|\1 0 2000 0750|
    s|^(vendor) .*|\1 0 2000 0755|
    s|^(config) .*|\1 0 0 0555|
    s|^(lost+found) .*|\1 0 0 0700|
    s|^(bin/[^ ]+) .*|\1 0 0 0644|
    s|^(init[^ ]*) .*|\1 0 2000 0750|

    # system

    s|^(system/bin) .*|\1 0 2000 0751|
    s|^(system/bin/[^ ]+) .*|\1 0 2000 0755|
    s|^(system/hw/bin) .*|\1 0 2000 0751|
    s|^(system/bin/hw) .*|\1 0 2000 0751|
    s|^(system/apex/com.android.art/bin) .*|\1 0 2000 0751|
    s|^(system/apex/com.android.art/bin/[^ ]+) .*|\1 0 2000 0755|
    s|^(system/apex/com.android.conscrypt/bin) .*|\1 0 2000 0751|
    s|^(system/apex/com.android.tethering.inprocess/bin) .*|\1 0 2000 0751|
    s|^(system/apex/com.android.tethering.inprocess/bin/for-system) .*|\1 0 2000 0751|
    s|^(system/apex/com.android.tethering.inprocess/bin/for-system/[^ ]+) .*|\1 0 2000 0755|
    s|^(system/apex/com.android.conscrypt/bin/[^ ]+) .*|\1 0 2000 0755|
    s|^(system/apex/com.android.runtime/bin) .*|\1 0 2000 0751|
    s|^(system/apex/com.android.runtime/bin/[^ ]+) .*|\1 0 2000 0755|
    s|^(system/apex/com.android.sdkext/bin) .*|\1 0 2000 0751|
    s|^(system/apex/com.android.sdkext/bin/[^ ]+) .*|\1 0 2000 0755|
    s|^(system/apex/com.android.media.swcodec/bin) .*|\1 0 2000 0751|
    s|^(system/apex/com.android.media.swcodec/bin/[^ ]+) .*|\1 0 2000 0755|
    s|^(system/apex/com.android.media/bin) .*|\1 0 2000 0751|
    s|^(system/apex/com.android.media/bin/[^ ]+) .*|\1 0 2000 0755|
    s|^(system/apex/com.android.tethering/bin) .*|\1 0 2000 0751|
    s|^(system/apex/com.android.tethering/bin/for-system) .*|\1 0 2000 0751|
    s|^(system/apex/com.android.tethering/bin/for-system/[^ ]+) .*|\1 0 2000 0755|
    s|^(system/apex/com.android.os.statsd/bin) .*|\1 0 2000 0751|
    s|^(system/apex/com.android.os.statsd/bin/[^ ]+) .*|\1 0 2000 0755|
    s|^(system/apex/com\.android\.adbd/bin) .*|\1 0 2000 0751|
    s|^(system/apex/com\.android\.adbd/bin/adbd) .*|\1 0 2000 0755|

    s|^(system/apex/com.android.art.debug/bin) .*|\1 0 2000 0751|
    s|^(system/apex/com.android.art.debug/bin/[^ ]+) .*|\1 0 2000 0755|

    s|^(system/etc/prop.default) .*|\1 0 0 0600|
    s|^(system/bin/crash_dump32) .*|\1 0 2000 0755|
    s|^(system/bin/crash_dump64) .*|\1 0 2000 0755|
    s|^(system/bin/install-recovery\.sh) .*|\1 0 0 0750|
    s|^(system/bin/debuggerd) .*|\1 0 2000 0755|
    s|^(system/bin/secilc) .*|\1 0 0 0700|
    s|^(system/bin/uncrypt) .*|\1 0 0 0750|
    s|^(system/build.prop) .*|\1 0 0 0600|
    s|^(system/etc/fs_config_dirs) .*|\1 0 0 0444|
    s|^(system/etc/fs_config_files) .*|\1 0 0 0444|
    s|^(system/etc/ppp/[^ ]+) .*|\1 0 0 0555|
    s|^(system/etc/init.ril) .*|\1 0 2000 0550|
    s|^(system/etc/rc.*) .*|\1 0 2000 0550|
    s|^(system/xbin/procmem) .*|\1 0 0 06755|
    s|^(system/xbin/su) .*|\1 0 2000 06750|

    # system_ext

    s|^(system_ext/build.prop) .*|\1 0 0 0600|
    s|^(system/system_ext/bin) .*|\1 0 2000 0751|
    s|^(system/apex/*/bin/*) .*|\1 0 2000 0755|
    s|^(system/system_ext/apex/*/bin/*) .*|\1 0 2000 0755|
    s|^(system_ext/apex/*/bin/*) .*|\1 0 2000 0755|
    s|^(system/system_ext/bin[^ ]+) .*|\1 0 2000 0755|
    s|^(system/system_ext/build.prop) .*|\1 0 0 0600|

    # product

    s|^(system/product/bin) .*|\1 0 2000 0751|
    s|^(system/product/bin/[^ ]+) .*|\1 0 2000 0755|
    s|^(system/product/apex/*/bin) .*|\1 0 2000 0755|
    s|^(system/product/build.prop) .*|\1 0 0 0600|

    # Apply vendor-specific permissions and capabilities.

    s|^(system/bin/logd) .*|\1 1036 1036 0550 capabilities=0x0|
    s|^(system/bin/bootstat) .*|\1 0 2000 0755 capabilities=0x0|
    s|^(system/bin/bootstrap) .*|\1 0 2000 0751 capabilities=0x0|
    s|^(system/bin/run-as) .*|\1 0 2000 0750 capabilities=0xc0|
    s|^(system/bin/surfaceflinger) .*|\1 0 2000 0755 capabilities=0x0|
    s|^(system/bin/simpleperf_app_runner) .*|\1 0 2000 0750 capabilities=0xc0|
"
cd ..
