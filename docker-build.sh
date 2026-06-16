#!/bin/bash
set -e
source config.sh

if [ $# -eq 0 ]; then
    echo "Usage: ./docker-build.sh VERSION [--no-cache]"
    echo "Example: ./docker-build.sh 6.18.2-1.0.0"
    echo "Example: ./docker-build.sh 6.18.2-1.0.0 --no-cache"
    echo ""
    echo "Available versions:"
    grep -v "^#" versions.txt | grep -v "^$" | awk '{printf "  %-20s Ubuntu %s\n", $1, $2}'
    exit 0
fi

VERSION=$1
NO_CACHE=""

# Check for --no-cache flag
if [ "$2" = "--no-cache" ]; then
    NO_CACHE="--no-cache"
    echo "Building with --no-cache flag"
fi

# Parse version config from versions.txt
parse_version_config "$VERSION"
if [ $? -ne 0 ]; then
    echo "Failed to parse version configuration"
    exit 1
fi

TAG="imx-docker:imx-${VERSION}"
IMX_RELEASE="imx-${VERSION}"

echo "Building Docker image for i.MX ${VERSION}"
echo "  Ubuntu:     ${UBUNTU}"
echo "  Branch:     ${BRANCH}"
echo "  Manifest:   ${MANIFEST}"
echo "  Dockerfile: ${DOCKERFILE}"
echo "  Tag:        ${TAG}"
echo ""

if [ ! -f "${DOCKERFILE}" ]; then
    echo "Error: ${DOCKERFILE} not found"
    exit 1
fi

if [ ! -f "yocto-build.sh" ]; then
    echo "Error: yocto-build.sh not found"
    exit 1
fi

docker build \
    ${NO_CACHE} \
    --build-arg IMX_RELEASE="${IMX_RELEASE}" \
    --build-arg BRANCH="${BRANCH}" \
    --build-arg MANIFEST="${MANIFEST}" \
    --build-arg MACHINE="${MACHINE}" \
    --build-arg DISTRO="${DISTRO}" \
    --build-arg IMAGES="${IMAGES}" \
    --build-arg REMOTE="${REMOTE}" \
    --build-arg DOCKER_WORKDIR="${DOCKER_WORKDIR}" \
    --build-arg USER=$(whoami) \
    --build-arg host_uid=$(id -u) \
    --build-arg host_gid=$(id -g) \
    -t ${TAG} -f ${DOCKERFILE} .

echo ""
echo "✅ Done: ${TAG}"
