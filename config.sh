#!/bin/bash

# Docker configuration
export DOCKER_WORKDIR="${HOME}/yocto-builds"

# Yocto build configuration
export REMOTE="https://github.com/nxp-imx/imx-manifest"

# Default build configuration (can be overridden)
export MACHINE="${MACHINE:-imx8mpevk}"
export DISTRO="${DISTRO:-fsl-imx-wayland}"
export IMAGES="${IMAGES:-imx-image-core}"

# Function to get version config from versions.txt
get_version_config() {
    local version=$1
    local versions_file="versions.txt"

    if [ ! -f "$versions_file" ]; then
        echo "Error: $versions_file not found" >&2
        return 1
    fi

    # Read config for the version (skip comments and empty lines)
    local config=$(grep -v "^#" "$versions_file" | grep -v "^$" | awk -v ver="$version" '$1 == ver {print}')

    if [ -z "$config" ]; then
        echo "Error: Version $version not found in $versions_file" >&2
        return 1
    fi

    echo "$config"
}

# Function to parse version config
parse_version_config() {
    local version=$1
    local config=$(get_version_config "$version")

    if [ $? -ne 0 ]; then
        return 1
    fi

    # Parse: VERSION UBUNTU BRANCH MANIFEST
    read -r VERSION UBUNTU BRANCH MANIFEST <<< "$config"

    export VERSION
    export UBUNTU
    export BRANCH
    export MANIFEST
    export DOCKERFILE="Dockerfile-Ubuntu-${UBUNTU}"
}
