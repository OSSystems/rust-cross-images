#!/usr/bin/env bash

# Script coppied from rust-embedded/cross to rework their Dockerfiles

set -x
set -euo pipefail

# For architectures except amd64 and i386, look for packages on ports.ubuntu.com instead.
# This is important if you enable additional architectures so you can install libraries to cross-compile against.
# Look for 'dpkg --add-architecture' in the README for more details.
if [ "${WITHOUT_PORTS:-no}" != "yes" ]; then
    sed 's/http:\/\/\(.*\).ubuntu.com\/ubuntu\//[arch-=amd64,i386] http:\/\/ports.ubuntu.com\/ubuntu-ports\//g' /etc/apt/sources.list > /etc/apt/sources.list.d/ports.list
    sed -i 's/http:\/\/\(.*\).ubuntu.com\/ubuntu\//[arch=amd64,i386] http:\/\/\1.archive.ubuntu.com\/ubuntu\//g' /etc/apt/sources.list
fi

apt-get update

apt-get install --assume-yes --no-install-recommends --allow-unauthenticated \
  autoconf \
  automake \
  binutils \
  ca-certificates \
  curl \
  file \
  gcc \
  g++ \
  git \
  libc6-dev \
  libtool \
  m4 \
  make \
  pkg-config
