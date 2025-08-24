#!/bin/sh
#
# Generate Android filesystem information for vendor_dlkm partition.
#
if [ $# -lt 1 ]; then
 echo "Usage: $0 VENDOR_DLKM_DIR"
fi

VENDOR_DLKM_DIR=$1

# Generate wildcard default permissions:
# https://android.googlesource.com/platform/system/core/+/refs/tags/android-vts-15.0_r5/libcutils/fs_config.cpp
# https://android.googlesource.com/platform/system/core/+/refs/tags/android-vts-15.0_r5/libcutils/include/private/android_filesystem_config.h

cd build

{ \
    find $VENDOR_DLKM_DIR -type d -printf "$1/%P 0 0 0755\n"; \
    find $VENDOR_DLKM_DIR -not -type d -printf "$1/%P 0 0 0644\n"; \
} | sed -r "
    s|^(vendor_dlkm/etc) .*|\1 0 0 0755|
    s|^(vendor_dlkm/etc/[^ ]+) .*|\1 0 0 0644|
    s|^(vendor_dlkm/lib) .*|\1 0 0 0755|
    s|^(vendor_dlkm/lib/[^ ]+) .*|\1 0 0 0644|
    s|^(vendor_dlkm/lib/modules) .*|\1 0 0 0755|
    s|^(vendor_dlkm/lib/modules/[^ ]+) .*|\1 0 0 0644|
    s|^(vendor_dlkm/lost+found) .*|\1 0 0 0700|
"
cd ..
