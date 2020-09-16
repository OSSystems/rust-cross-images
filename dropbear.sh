#!/usr/bin/env bash

# Script coppied from rust-embedded/cross to rework their Dockerfiles

set -x
set -euo pipefail

main() {
    local version=2020.80

    local dependencies=(
        autoconf
        automake
        bzip2
        make
        zlib1g-dev
    )

    if ! type curl 2> /dev/null; then
        dependencies+=( "curl" )
    fi

    apt-get update
    local purge_list=()
    for dep in "${dependencies[@]}"; do
        if ! dpkg -L "${dep}"; then
            apt-get install --assume-yes --no-install-recommends --allow-unauthenticated "${dep}"
            purge_list+=( "${dep}" )
        fi
    done

    local td
    td="$(mktemp -d)"

    pushd "${td}"

    curl --retry 3 -sSfL "https://matt.ucc.asn.au/dropbear/dropbear-${version}.tar.bz2" -O
    tar --strip-components=1 -xjf "dropbear-${version}.tar.bz2"

    # Remove some unwanted message
    sed -i '/skipping hostkey/d' cli-kex.c
    sed -i '/failed to identify current user/d' cli-runopts.c

    ./configure \
       --disable-syslog \
       --disable-shadow \
       --disable-lastlog \
       --disable-utmp \
       --disable-utmpx \
       --disable-wtmp \
       --disable-wtmpx \
       --disable-pututline \
       --disable-pututxline

    make "-j$(nproc)" PROGRAMS=dbclient
    cp dbclient /usr/local/bin/

    if (( ${#purge_list[@]} )); then
      apt-get purge --assume-yes --auto-remove "${purge_list[@]}"
    fi

    popd

    rm -rf "${td}"
    rm "${0}"
}

main "${@}"
