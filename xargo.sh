#!/usr/bin/env bash

# Script coppied from rust-embedded/cross to rework their Dockerfiles

set -x
set -euo pipefail

main() {
    local dependencies=(
        ca-certificates
        curl
    )

    apt-get update
    local purge_list=()
    for dep in "${dependencies[@]}"; do
        if ! dpkg -L "${dep}"; then
            apt-get install --assume-yes --no-install-recommends "${dep}"
            purge_list+=( "${dep}" )
        fi
    done

    export RUSTUP_HOME=/tmp/rustup
    export CARGO_HOME=/tmp/cargo

    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o rustup-init.sh
    sh rustup-init.sh -y --no-modify-path --profile minimal
    rm rustup-init.sh

    PATH="${CARGO_HOME}/bin:${PATH}" cargo install xargo --root /usr/local

    rm -r "${RUSTUP_HOME}" "${CARGO_HOME}"

    if (( ${#purge_list[@]} )); then
      apt-get purge --assume-yes --auto-remove "${purge_list[@]}"
    fi

    rm "${0}"
}

main "${@}"
