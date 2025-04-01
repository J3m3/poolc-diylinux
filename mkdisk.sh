#!/bin/bash

set -e

if [[ "$(pwd)" != "/distro" ]]; then
  echo "Error: This script must be executed from /distro"
  exit 1
fi

img="disk.img"
block_dev=""
mount_point="mnt"

cleanup() {
  if [[ -n $block_dev ]]; then
    umount --all-targets $block_dev 2>/dev/null
    losetup -d $block_dev
  fi
  rmdir $mount_point 2>/dev/null
  rm -f $img
  exit 1
}

trap cleanup INT TERM ERR

cp /linux/arch/arm64/boot/Image .

cd initramfs && find . | cpio -o -H newc > ../initramfs.cpio && cd ..

dd if=/dev/zero of=$img bs=1M count=36
block_dev=$(losetup -f --show disk.img)
mkfs.vfat -F32 $block_dev

refind-install --usedefault $block_dev

mkdir -p $mount_point
mount $block_dev $mount_point

mv $mount_point/EFI/BOOT/refind_aa64.efi $mount_point/EFI/BOOT/BOOTAA64.efi

cp Image initramfs.cpio $mount_point/EFI/BOOT

CFG_PATH="mnt/EFI/BOOT/refind.conf"
echo "timeout 10" > $CFG_PATH
echo "textonly" >> $CFG_PATH
echo "menuentry \"Custom Linux\" {" >> $CFG_PATH
echo "loader /EFI/BOOT/Image" >> $CFG_PATH
echo "initrd /EFI/BOOT/initramfs.cpio" >> $CFG_PATH
echo "options \"console=ttyAMA0\"" >> $CFG_PATH
echo "}" >> $CFG_PATH

umount --all-target $block_dev
losetup -d $block_dev
