#!/bin/sh
#
# Test a repacked image which should preserve all the permissions, modes, labels and capabilities
#

if [ "$#" -lt '1' ]; then
    echo "Usage: $0 SPARSE_CUSTOM_IMAGE"
    exit
fi

if [ -f "$1" ]; then
    CUSTOM_IMAGE="$(readlink -f "$1")"
elif [ -n "$2" ]; then
    echo -e "\n\033[1m\033[33m$1 don't exist,`
	` please apply <mod-super>!\033[0m"
    exit 2
else
    echo -e "\n\033[1m\033[33m$1 don't exist,`
	` please apply <mod-partition-all>!\033[0m"
    exit 2
fi

if [ -n "$2" ]; then
    CUSTOM_EXT_IMAGE="$(realpath "$2")"
fi

SIMG2IMG="simg2img"
script_root="$(dirname "$(readlink -f "$0")")"
tmp_name="$(basename -s .sparseimg "$CUSTOM_IMAGE")"
tmp_mnt="$tmp_name"
tmp_img_fs="${tmp_name}.fs_config_custom.txt"
STOCK_FS="${tmp_name}.fs_config_stock.txt"

cd "$script_root" || exit
mkdir -p "$tmp_mnt"

if [ -f "$CUSTOM_EXT_IMAGE" ]; then
    tmp_img="$CUSTOM_IMAGE"
elif [ -z "$2" ]; then
    tmp_img="${tmp_name}.img"
fi

if [ -z "$2" ]; then
    echo "convert to unsparse..."
    "$SIMG2IMG" "$CUSTOM_IMAGE" "$tmp_img"
fi

echo "mount unsparseimg..."
sudo mount -t ext4 -o ro,loop "$tmp_img" "$tmp_mnt"
echo "dump $tmp_name filesystem..."
sudo ./dump_android_filesystem.sh "$tmp_mnt" | tee "$tmp_img_fs" > /dev/null 2>&1
sudo umount "$tmp_mnt"

if [ "$tmp_img" = "${tmp_name}.img" ]; then
    rm "$tmp_img"
    rmdir "$tmp_mnt"
else
    rmdir "$tmp_mnt"
fi

compare () {
    compare="$(diff "$tmp_img_fs" "$STOCK_FS" | grep ">")"
}; compare

if [ "$compare" != "" ]; then
    printf "%s\n" "failed fs_config for repacked image is at $(readlink -f "$tmp_img_fs")"
    printf '\e[33m%s\n\e[0m\n' "Check the original and custom $tmp_name for inconsistencies!"
    printf '\e[31m%s\n\e[0m' "< custom"
    printf '\e[32m%s\n\e[0m\n' "> stock"
    diff --color=auto "$tmp_img_fs" "$STOCK_FS"
    printf "%s\n" "---"
    exit 0
fi

compare=$?
if [ "$compare" -eq "0" ]; then
    printf '\e[32m%s\n\e[0m\n' "test OK!"
fi

