#!/bin/sh
#
# Generate Android filesystem information for vendor partition.
#
if [ $# -lt 1 ]; then
    echo "Usage: $0 VENDOR_DIR"
fi

VENDOR_DIR=$1

# Generate wildcard default permissions:
# https://android.googlesource.com/platform/system/core/+/refs/tags/android-vts-15.0_r5/libcutils/fs_config.cpp
# https://android.googlesource.com/platform/system/core/+/refs/tags/android-vts-15.0_r5/libcutils/include/private/android_filesystem_config.h

cd build

{ \
    find $VENDOR_DIR -type d -printf "$1/%P 0 0 0755\n"; \
    find $VENDOR_DIR -not -type d -printf "$1/%P 0 2000 0755\n"; \
} | sed -r "
    s|^(vendor/etc) .*|\1 0 2000 0755|
    s|^(vendor/etc/[^ ]+) .*|\1 0 0 0644|
    s|^(vendor/etc/aidl) .*|\1 0 2000 0755|
    s|^(vendor/etc/aidl/hfp) .*|\1 0 2000 0755|
    s|^(vendor/etc/aidl/le_audio) .*|\1 0 2000 0755|
    s|^(vendor/etc/bpf) .*|\1 0 2000 0755|
    s|^(vendor/etc/res) .*|\1 0 2000 0755|
    s|^(vendor/etc/res/images) .*|\1 0 2000 0755|
    s|^(vendor/etc/res/images/charger) .*|\1 0 2000 0755|
    s|^(vendor/etc/res/values) .*|\1 0 2000 0755|
    s|^(vendor/etc/res/values/charger) .*|\1 0 2000 0755|
    s|^(vendor/etc/init) .*|\1 0 2000 0755|
    s|^(vendor/etc/init.d) .*|\1 0 2000 0755|
    s|^(vendor/etc/init/hw) .*|\1 0 2000 0755|
    s|^(vendor/etc/init/permissions) .*|\1 0 2000 0755|
    s|^(vendor/etc/seccomp_policy) .*|\1 0 2000 0755|
    s|^(vendor/etc/selinux) .*|\1 0 2000 0755|
    s|^(vendor/etc/tvconfig) .*|\1 0 2000 0755|
    s|^(vendor/etc/tvconfig/pq) .*|\1 0 2000 0755|
    s|^(vendor/etc/vintf) .*|\1 0 2000 0755|
    s|^(vendor/etc/vintf/manifest) .*|\1 0 2000 0755|
    s|^(vendor/framework/[^ ]+) .*|\1 0 0 0644|
    s|^(vendor/etc/wifi) .*|\1 0 2000 0755|
    s|^(vendor/etc/wifi/62x2) .*|\1 0 2000 0755|
    s|^(vendor/etc/wifi/4335) .*|\1 0 2000 0755|
    s|^(vendor/etc/wifi/6255) .*|\1 0 2000 0755|
    s|^(vendor/etc/wifi/6256) .*|\1 0 2000 0755|
    s|^(vendor/etc/wifi/ap6275p) .*|\1 0 2000 0755|
    s|^(vendor/etc/wifi/ap6276p) .*|\1 0 2000 0755|
    s|^(vendor/etc/wifi/ssv6051) .*|\1 0 2000 0755|
    s|^(vendor/etc/wifi/qca9377) .*|\1 0 2000 0755|
    s|^(vendor/etc/wifi/qca9377/wlan) .*|\1 0 2000 0755|
    s|^(vendor/etc/wifi/qca6174) .*|\1 0 2000 0755|
    s|^(vendor/etc/wifi/qca6174/wlan) .*|\1 0 2000 0755|
    s|^(vendor/etc/wifi/buildin) .*|\1 0 2000 0755|
    s|^(vendor/etc/bluetooth) .*|\1 0 2000 0755|
    s|^(vendor/etc/bluetooth/qca9377) .*|\1 0 2000 0755|
    s|^(vendor/etc/bluetooth/qca9377/ar3k) .*|\1 0 2000 0755|
    s|^(vendor/etc/bluetooth/qca6174) .*|\1 0 2000 0755|
    s|^(vendor/etc/bluetooth/qca6174/ar3k) .*|\1 0 2000 0755|
    s|^(vendor/etc/permissions) .*|\1 0 2000 0755|
    s|^(vendor/firmware) .*|\1 0 2000 0755|
    s|^(vendor/firmware/[^ ]+) .*|\1 0 0 0644|
    s|^(vendor/framework) .*|\1 0 2000 0755|
    s|^(vendor/framework/oat) .*|\1 0 2000 0755|
    s|^(vendor/framework/droidlogic-tv.jar) .*|\1 0 0 0644|
    s|^(vendor/framework/droidlogic.jar) .*|\1 0 0 0644|
    s|^(vendor/framework/oat/arm) .*|\1 0 2000 0755|
    s|^(vendor/framework/oat/arm/[^ ]+) .*|\1 0 0 0644|
    s|^(vendor/lib) .*|\1 0 2000 0755|
    s|^(vendor/lib/[^ ]+) .*|\1 0 0 0644|
    s|^(vendor/lib/egl) .*|\1 0 2000 0755|
    s|^(vendor/lib/firmware) .*|\1 0 2000 0755|
    s|^(vendor/lib/firmware/gdc) .*|\1 0 2000 0755|
    s|^(vendor/lib/firmware/video) .*|\1 0 2000 0755|
    s|^(vendor/lib/hw) .*|\1 0 2000 0755|
    s|^(vendor/lib/hw/[^ ]+) .*|\1 0 0 0644|
    s|^(vendor/lib/mediacas) .*|\1 0 2000 0755|
    s|^(vendor/lib/mediadrm) .*|\1 0 2000 0755|
    s|^(vendor/lib/modules) .*|\1 0 0 0644|
    s|^(vendor/lib/soundfx) .*|\1 0 2000 0755|
    s|^(vendor/odm) .*|\1 0 0 0644|
    s|^(vendor/odm_dlkm) .*|\1 0 2000 0755|
    s|^(vendor/odm_dlkm/etc) .*|\1 0 2000 0755|
    s|^(vendor/odm_dlkm/etc/[^ ]+) .*|\1 0 0 0644|
    s|^(vendor/overlay) .*|\1 0 2000 0755|
    s|^(vendor/overlay/[^ ]+) .*|\1 0 0 0644|
    s|^(vendor/usr) .*|\1 0 2000 0755|
    s|^(vendor/usr/idc) .*|\1 0 2000 0755|
    s|^(vendor/usr/idc/[^ ]+) .*|\1 0 0 0644|
    s|^(vendor/usr/keylayout) .*|\1 0 2000 0755|
    s|^(vendor/usr/keylayout/[^ ]+) .*|\1 0 0 0644|
    s|^(vendor/vendor_dlkm) .*|\1 0 2000 0755|
    s|^(vendor/vendor_dlkm/etc) .*|\1 0 2000 0755|
    s|^(vendor/vendor_dlkm/etc/[^ ]+) .*|\1 0 0 0644|
    s|^(vendor/media/video_samples) .*|\1 0 2000 0755|
    s|^(vendor/build.prop) .*|\1 0 0 0600|
    s|^(vendor/default.prop) .*|\1 0 0 0600|
    s|^(vendor/etc/fs_config_files) .*|\1 0 0 0444|
    s|^(vendor/etc/recovery.img) .*|\1 0 0 0440|
    s|^(vendor/etc/fs_config_dirs) .*|\1 0 0 0444|
    s|^(vendor/bin) .*|\1 0 2000 0751|
    s|^(vendor/bin/hw) .*|\1 0 2000 0751|
    s|^(vendor/xbin/[^ ]+) .*|\1 0 2000 0755|
    s|^(vendor/apex/*bin/*) .*|\1 0 2000 0755|
    s|^(vendor/lost+found) .*|\1 0 0 0700|
    s|^(vendor/bin/install-recovery.sh) .*|\1 0 0 0750|

    # Apply vendor-specific permissions and capabilities.

    s|^(vendor/bin/cnd) .*|\1 1000 1000 0755 capabilities=0x1000001400|
    s|^(vendor/bin/hostapd) .*|\1 0 2000 0755 capabilities=0x3000|
"
cd ..

