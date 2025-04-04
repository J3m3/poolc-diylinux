# syntax=docker/dockerfile:1-labs

# The above directive is required since we use `--security=insecure`.
# This ensures `losetup` and `mount` work properly during build.
# I leave the commands I used to build images as a reference.
#
# 1. Creating a new privileged builder instance
# docker buildx create --use --name insecure-builder --buildkitd-flags '--allow-insecure-entitlement security.insecure'
#
# 2. Build multi-platform images with it
# docker buildx build --allow security.insecure --platform linux/arm64,linux/amd64 .
#
# 3. Delete the instance
# docker buildx rm insecure-builder
#
# 4. Clean build cache
# docker buildx prune

FROM ubuntu:noble

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y --no-install-recommends \
    # Kernel & Busybox build dependencies
    git gcc gcc-aarch64-linux-gnu make bash binutils pkg-config \
    flex bison dwarves perl bc gawk libncurses-dev libssl-dev \ 
    libelf-dev bzip2 \
    # Userspace cross compilation support
    gcc-arm-linux-gnueabi gdb-multiarch libc6-dev-armel-cross \
    libc6-dev-arm64-cross \
    # QEMU tools
    qemu-system qemu-efi-aarch64 \
    # Etc
    cpio dosfstools gdisk wget python3 vim bear clangd file unzip \  
    ca-certificates \
    && apt clean && rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 --branch v6.13 git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
RUN git clone --depth 1 --branch 1_36_stable git://git.busybox.net/busybox.git

ENV ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu-

RUN mkdir -p distro/initramfs

WORKDIR /linux
COPY .config.kernel .config
RUN make -j$(nproc) && cp arch/arm64/boot/Image distro

WORKDIR /busybox
COPY .config.busybox .config
RUN make -j$(nproc) && make CONFIG_PREFIX=/distro/initramfs install

WORKDIR /distro/initramfs
RUN mkdir -p proc sys dev \
    && rm -f linuxrc \
    && echo "#!/bin/sh" > init \
    && echo "mount -t proc none /proc" >> init \
    && echo "mount -t sysfs none /sys" >> init \
    && echo "mount -t devtmpfs none /dev" >> init \
    && echo "setsid sh -c 'exec sh </dev/ttyAMA0 >/dev/ttyAMA0 2>&1'" >> init \
    && chmod +x init

WORKDIR /distro
ARG REFIND_VER=0.14.2
RUN wget -q https://sourceforge.net/projects/refind/files/$REFIND_VER/refind-bin-$REFIND_VER.zip \
    && unzip refind-bin-$REFIND_VER.zip \
    && rm -f refind-bin-$REFIND_VER.zip
COPY mkdisk.sh boot.sh ./
RUN chmod +x mkdisk.sh boot.sh
RUN --security=insecure ./mkdisk.sh

RUN cp /usr/share/qemu-efi-aarch64/QEMU_EFI.fd . \
    && truncate -s 64M efivars.img \
    && truncate -s 64M eficode.img \
    && dd if=QEMU_EFI.fd of=eficode.img conv=notrunc
