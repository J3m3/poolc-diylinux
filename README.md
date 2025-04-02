# poolc-diylinux

> [!NOTE]
> 연세대학교 공과대학 프로그래밍 동아리 [풀씨](https://poolc.org/)에서 진행한 `DIY Linux` 세미나 자료입니다.

![PoolC Banner](https://poolc.org/assets/main-banner-DAW2HCpy.png)

## Table of contents

1. **Baking a Distro**

   - Compiling Linux kernel
   - Setting up essential utilities (cd, ls, etc.)
   - Configuring a UEFI-based bootloader
   - Booting into _MyOwnLinux_

2. **Hacking the Kernel**

   - A quick dive into `task_struct`
   - Implementing a custom system call
   - Handling user-kernel data transfers
   - Overview of kernel locking mechanisms

## References

### Building Linux

- [Minimal requirements to compile the Kernel](https://docs.kernel.org/process/changes.html)
- [buildroot/board/qemu/aarch64-virt/linux.config](https://github.com/buildroot/buildroot/blob/master/board/qemu/aarch64-virt/linux.config)
- [Compiling a kernel for QEMU with graphics support](https://github.com/byte4RR4Y/aarch64-kernel-for-qemu)

### Building Busybox

- [[Bug 15934] New: Busybox fails to build with linux kernels >= 6.8](https://lists.busybox.net/pipermail/busybox-cvs/2024-January/041752.html)

### Booting

- [archlinux wiki: QEMU - Booting in UEFI mode](https://wiki.archlinux.org/title/QEMU#Booting_in_UEFI_mode)
- [UEFI, PC boot process and UEFI with QEMU](https://joonas.fi/2021/02/uefi-pc-boot-process-and-uefi-with-qemu/)
- [arch linux arm aarch64 + ovmf uefi + qemu](https://xnand.netlify.app/2019/10/03/armv8-qemu-efi-aarch64.html)
- [How to boot a desired partition of a UEFI disk with Qemu?](https://unix.stackexchange.com/questions/787873/how-to-boot-a-desired-partition-of-a-uefi-disk-with-qemu)
- [Booting AArch64 Linux](https://www.kernel.org/doc/html/latest/arch/arm64/booting.html)
- [Boot ARM64 virtual machines on QEMU](https://documentation.ubuntu.com/server/how-to/virtualisation/arm64-vms-on-qemu/index.html)
- [QEMU에서 u-boot와 Initramfs를 이용하여 AARCH64 리눅스 커널 부팅](https://velog.io/@dovob/QEMU%EC%97%90%EC%84%9C-u-boot%EC%99%80-Initramfs%EB%A5%BC-%EC%9D%B4%EC%9A%A9%ED%95%98%EC%97%AC-AARCH64-%EB%A6%AC%EB%88%85%EC%8A%A4%EC%BB%A4%EB%84%90-%EB%B6%80%ED%8C%85)
- [Booting Linux with U-Boot on QEMU ARM](https://balau82.wordpress.com/2010/04/12/booting-linux-with-u-boot-on-qemu-arm/)
- [buildroot/boot/grub2/readme.txt](https://github.com/buildroot/buildroot/tree/master/boot/grub2)

### QEMU

- [‘virt’ generic virtual platform (virt)](https://qemu-project.gitlab.io/qemu/system/arm/virt.html)
- [Features/PC System Flash](https://wiki.qemu.org/Features/PC_System_Flash)
- [QEMU: How come ARM ISO image need pflash/bios, but not X86 ISO image](https://stackoverflow.com/questions/78640741/qemu-how-come-arm-iso-image-need-pflash-bios-but-not-x86-iso-image)

### Etc

- [Cannot format my EFI partition (FAT32)](https://unix.stackexchange.com/questions/440988/cannot-format-my-efi-partition-fat32)
- [qemu-system-aarch64: initialization of device cfi.pflash01 failed : device requires 67108864 bytes,block backend provides 67112960 bytes...](https://www.reddit.com/r/freebsd/comments/12ijb2s/qemusystemaarch64_initialization_of_device/)
  - [edk2 quickstart for virtualization](https://www.kraxel.org/blog/2022/05/edk2-virt-quickstart/)
- [Linux Serial Console](https://docs.kernel.org/admin-guide/serial-console.html)
- [u-boot/doc/README.qemu-arm](https://github.com/ARM-software/u-boot/blob/master/doc/README.qemu-arm)
- [Virtio: An I/O virtualization framework for Linux](https://developer.ibm.com/articles/l-virtio/)
- [Compiling the Linux kernel and creating a bootable ISO from it](https://medium.com/@ThyCrow/compiling-the-linux-kernel-and-creating-a-bootable-iso-from-it-6afb8d23ba22)
- [AArch64 legacy BIOS boot](https://forum.osdev.org/viewtopic.php?t=57316)
- [커널 이미지](http://jake.dothome.co.kr/image1/)
- [[Buildroot] 임베디드 리눅스 구조의 이해](https://underflow101.tistory.com/32)

### Debugging w/ QEMU

- [Is it possible to use gdb and qemu to debug linux user space programs and kernel space simultaneously?](https://stackoverflow.com/questions/26271901/is-it-possible-to-use-gdb-and-qemu-to-debug-linux-user-space-programs-and-kernel)
- [Linux Kernel Debugging](https://cs4118.github.io/dev-guides/kernel-debugging.html)

### System call implementation

- [Adding a New System Call](https://docs.kernel.org/process/adding-syscalls.html)
- [[PATCH 00/17] arch: convert everything to syscall.tbl](https://lore.kernel.org/lkml/CAJF2gTQuu3SBKR-Q7+njKqbXZsRgWHjfDBYgBGMbERpuqWKjew@mail.gmail.com/T)

### Inspired by

- [Linux From Scratch](https://www.linuxfromscratch.org/)
- [Making Smallest Possible Linux Distro (x64)](https://www.youtube.com/watch?v=u2Juz5sQyYQ)
- [Adding Simple System Call in Linux Kernel](https://www.youtube.com/watch?v=Kn6D7sH7Fts)
- [Linux From Nothing | Kernel, Shell, Libs & Grub](https://www.youtube.com/watch?v=fk-KGj3pimA)

## License

[MIT License](LICENSE)
