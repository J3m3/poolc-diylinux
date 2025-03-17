#!/bin/bash

set +xe

print_help() {
  echo "Usage:"
  echo "  ./boot.sh --direct          Boot directly from the kernel image."
  echo "  ./boot.sh --image           Boot from the bootable disk image."
}

if [ $# -eq 0 ] || [ "$1" == "-h" ]; then
  print_help
  exit 0
fi

if [ "$1" == "--direct" ]; then
  qemu-system-aarch64 \
    -machine virt,acpi=off \
    -cpu cortex-a53 \
    -smp 2 \
    -m 1G \
    -kernel distro/Image.gz \
    -initrd distro/initramfs.cpio \
    -append "console=ttyAMA0" \
    -nographic
elif [ "$1" == "--image" ]; then
  qemu-system-aarch64 \
    -machine virt,acpi=off \
    -cpu cortex-a53 \
    -smp 2 \
    -m 1G \
    -drive if=pflash,format=raw,file=distro/eficode.img,readonly=on \
    -drive if=pflash,format=raw,file=distro/efivars.img \
    -drive file=distro/disk.img,format=raw,if=virtio \
    -nographic
else
  print_help
  exit 1
fi