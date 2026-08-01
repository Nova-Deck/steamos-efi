# steamos-efi aarch64 build environment — native arm64.
#
# Built on GitHub's arm64 hosted runners (ubuntu-24.04-arm), so no multiarch or
# qemu is involved: gnu-efi and the aarch64 toolchain install as the host arch.
# Mirrors the build deps of novadeck's build/Dockerfile (the container
# boot/steamcl.sh runs in), minus what this fork does not need.
FROM ubuntu:26.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
      build-essential \
      gcc-aarch64-linux-gnu \
      gnu-efi \
      autoconf automake libtool pkg-config \
      fontconfig fonts-dejavu-core \
      grub-common \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src
