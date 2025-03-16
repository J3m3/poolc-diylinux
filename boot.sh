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
    -kernel Image.gz \
    -initrd initramfs.cpio \
    -append "console=ttyAMA0" \
    -nographic
elif [ "$1" == "--image" ]; then
  qemu-system-aarch64 \
    -machine virt,acpi=off \
    -cpu cortex-a53 \
    -smp 2 \
    -m 1G \
    -drive file=disk.img,format=raw,if=virtio \
    -bios QEMU_EFI.fd \
    -nographic
else
  print_help
  exit 1
fi