#!/bin/bash

set -e

trap "umount mnt 2>/dev/null || true; exit 1" ERR INT TERM

if [[ "$(pwd)" != "/distro" ]]; then
  echo "Error: This script must be executed from /distro"
  exit 1
fi

cp /linux/arch/arm64/boot/Image.gz .

dd if=/dev/zero of=disk.img bs=1M count=36
mkfs.vfat -F32 -n EFI disk.img
mkdir -p mnt
mount disk.img mnt
grub-install --target=arm64-efi --efi-directory=mnt --boot-directory=mnt --removable

grub_cfg_path="mnt/EFI/BOOT/grub.cfg"

echo "set timeout=10" > "$grub_cfg_path"
echo "set default=0" >> "$grub_cfg_path"
echo "menuentry \"Linux Kernel\" {" >> "$grub_cfg_path"
echo "    linux /boot/Image.gz console=ttyAMA0" >> "$grub_cfg_path"
echo "    initrd /boot/initramfs.cpio" >> "$grub_cfg_path"
echo "}" >> "$grub_cfg_path"

mkdir mnt/boot
cp Image.gz initramfs.cpio mnt/boot
umount mnt