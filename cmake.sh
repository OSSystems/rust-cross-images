#!/usr/bin/env bash

# Script coppied from rust-embedded/cross to rework their Dockerfiles

set -x
set -euo pipefail

main() {
    local version=3.17.2

    local dependencies=(curl)

    local purge_list=()
    if ! type curl 2> /dev/null; then
        apt-get update
        for dep in "${dependencies[@]}"; do
            if ! dpkg -L "${dep}"; then
                apt-get install --assume-yes --no-install-recommends "${dep}"
                purge_list+=( "${dep}" )
            fi
        done
    fi

    local td
    td="$(mktemp -d)"

    pushd "${td}"

    curl --retry 3 -sSfL "https://github.com/Kitware/CMake/releases/download/v${version}/cmake-${version}-Linux-x86_64.sh" -o cmake.sh
    sh cmake.sh --skip-license --prefix=/usr/local

    popd

    if (( ${#purge_list[@]} )); then
      apt-get purge --assume-yes --auto-remove "${purge_list[@]}"
    fi

    rm -rf "${td}"
    rm -rf /var/lib/apt/lists/*
    rm "${0}"
}

main "${@}"
