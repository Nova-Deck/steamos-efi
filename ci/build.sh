#!/usr/bin/env bash
# Build steamos-efi for aarch64, natively inside the arm64 CI image.
#
# Mirrors boot/steamcl.sh (novadeck repo) — the same configure/make commands,
# run on a native arm64 runner instead of an amd64 one with a cross toolchain.
set -euo pipefail

autoreconf -ivf
./configure --host=aarch64-linux-gnu --prefix=/usr --with-release-version=ci
make -j"$(nproc)"
