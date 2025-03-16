# Use --privileged option when running the container from the built image
# This is necessary since we're going to use mount(8) command

FROM ubuntu:noble

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y --no-install-recommends git \
  gcc \  
  gcc-aarch64-linux-gnu \
  make \
  bash \
  binutils \
  pkg-config \
  flex \
  bison \
  dwarves \
  perl \
  bc \
  gawk \
  libncurses-dev \
  libssl-dev \
  libelf-dev \
  bzip2

RUN git clone --depth 1 --branch v6.13 git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
RUN git clone --depth 1 git://busybox.net/busybox.git

RUN apt install -y --no-install-recommends \
  cpio \
  grub-efi-arm64 \
  grub-efi-arm64-bin \
  dosfstools \
  gdisk \
  python3 \
  vim \
  bear

ENV ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu-