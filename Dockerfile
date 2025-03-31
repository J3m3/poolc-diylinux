# Use --privileged option when running a container from the built image
# This is necessary since we're going to use mount(8) command

FROM ubuntu:noble

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y --no-install-recommends \
  git gcc gcc-aarch64-linux-gnu make bash binutils pkg-config \
  flex bison dwarves perl bc gawk libncurses-dev libssl-dev \ 
  libelf-dev bzip2 \
  && apt clean && rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 --branch v6.13 git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
RUN git clone --depth 1 git://busybox.net/busybox.git

RUN apt update && apt install -y --no-install-recommends \
  cpio dosfstools gdisk wget python3 vim bear clangd file \
  gcc-arm-linux-gnueabi gdb-multiarch qemu-system qemu-efi-aarch64 \
  && apt clean && rm -rf /var/lib/apt/lists/*

ENV ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu-
