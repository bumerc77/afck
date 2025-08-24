#!/bin/sh
#
# Generate Android filesystem information for odm partition.
#
if [ $# -lt 1 ]; then
    echo "Usage: $0 ODM_DIR"
fi

ODM_DIR=$1

# Generate wildcard default permissions:
# https://android.googlesource.com/platform/system/core/+/refs/tags/android-vts-15.0_r5/libcutils/fs_config.cpp
# https://android.googlesource.com/platform/system/core/+/refs/tags/android-vts-15.0_r5/libcutils/include/private/android_filesystem_config.h

cd build

{ \
    find $ODM_DIR -type d -printf "$1/%P 0 0 0755\n"; \
    find $ODM_DIR -not -type d -printf "$1/%P 0 0 0644\n"; \
} | sed -r "
    s|^(odm/etc/selinux) .*|\1 0 0 0755|
    s|^(odm/etc/fs_config_files) .*|\1 0 0 0444|
    s|^(odm/etc/fs_config_dirs) .*|\1 0 0 0444|
    s|^(odm/etc/build.prop) .*|\1 0 0 0600|
    s|^(odm/build.prop) .*|\1 0 0 0600|
    s|^(odm/default.prop) .*|\1 0 0 0600|
"
cd ..
