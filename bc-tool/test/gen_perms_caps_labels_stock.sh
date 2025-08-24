#!/bin/sh
#
# Test a repacked image which should preserve all the permissions, modes, labels and capabilities
#

if [ "$#" -lt '1' ]; then
    echo "Usage: $0 SPARSE_STOCK_IMAGE"
    exit
fi

STOCK_IMAGE="$(readlink -f "$1")"
SIMG2IMG="simg2img"

script_root="$(dirname "$(readlink -f "$0")")"
tmp_name="$(basename -s .sparseimg "$STOCK_IMAGE")"
tmp_mnt="$tmp_name"
tmp_img_fs="${tmp_name}.fs_config_stock.txt"

cd "$script_root" || exit
mkdir -p "$tmp_mnt"

if [ -n "$2" ]; then
    tmp_img="$STOCK_IMAGE"
elif [ -z "$2" ]; then
    tmp_img="${tmp_name}.img"
fi

if [ -z "$2" ]; then
    echo "convert to unsparse..."
    "$SIMG2IMG" "$STOCK_IMAGE" "$tmp_img"
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
