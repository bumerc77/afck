#!/bin/sh
#
# Generate Android filesystem information for product partition.
#
if [ $# -lt 1 ]; then
    echo "Usage: $0 PRODUCT_DIR"
fi

PRODUCT_DIR=$1

# Generate wildcard default permissions:
# https://android.googlesource.com/platform/system/core/+/refs/tags/android-vts-15.0_r5/libcutils/fs_config.cpp
# https://android.googlesource.com/platform/system/core/+/refs/tags/android-vts-15.0_r5/libcutils/include/private/android_filesystem_config.h

cd build

{ \
    find $PRODUCT_DIR -type d -printf "$1/%P 0 0 0755\n"; \
    find $PRODUCT_DIR -not -type d -printf "$1/%P 0 0 0644\n"; \
} | sed -r "
    s|^(product/bin) .*|\1 0 2000 0751|
    s|^(product/bin/[^ ]+) .*|\1 0 2000 0755|
    s|^(product/apex/*/bin) .*|\1 0 2000 0755|
    s|^(product/etc/fs_config_files) .*|\1 0 0 0444|
    s|^(product/etc/fs_config_dirs) .*|\1 0 0 0444|
    s|^(product/lost+found) .*|\1 0 0 0700|
    s|^(product/build.prop) .*|\1 0 0 0600|
"
cd ..
