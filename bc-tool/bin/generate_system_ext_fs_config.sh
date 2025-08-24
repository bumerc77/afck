#!/bin/sh
#
# Generate Android filesystem information for odm partition.
#
if [ $# -lt 1 ]; then
    echo "Usage: $0 SYSTEM_EXT_DIR"
fi

SYSTEM_EXT_DIR=$1

# Generate wildcard default permissions:
# https://android.googlesource.com/platform/system/core/+/refs/tags/android-vts-15.0_r5/libcutils/fs_config.cpp
# https://android.googlesource.com/platform/system/core/+/refs/tags/android-vts-15.0_r5/libcutils/include/private/android_filesystem_config.h

cd build

{ \
    find $SYSTEM_EXT_DIR -type d -printf "$1/%P 0 0 0755\n"; \
    find $SYSTEM_EXT_DIR -not -type d -printf "$1/%P 0 0 0644\n"; \
} | sed -r "
    s|^(system_ext/bin) .*|\1 0 2000 0751|
    s|^(system_ext/bin/[^ ]+) .*|\1 0 2000 0755|
    s|^(system_ext/bin/hw) .*|\1 0 2000 0751|
    s|^(system_ext/etc/fs_config_dirs) .*|\1 0 0 0444|
    s|^(system_ext/etc/fs_config_files) .*|\1 0 0 0444|
    s|^(system_ext/build.prop) .*|\1 0 0 0600|
    s|^(system/system_ext/bin) .*|\1 0 2000 0751|
    s|^(system/apex/*/bin/*) .*|\1 0 2000 0755|
    s|^(system/system_ext/apex/*/bin/*) .*|\1 0 2000 0755|
    s|^(system_ext/apex/*/bin/*) .*|\1 0 2000 0755|
    s|^(system/system_ext/bin[^ ]+) .*|\1 0 2000 0755|
    s|^(system/system_ext/build.prop) .*|\1 0 0 0600|
"
cd ..
