#!/bin/bash
set -e
source config.sh

if [ $# -eq 0 ]; then
    echo "Usage: ./docker-run.sh VERSION [COMMAND]"
    echo "Example: ./docker-run.sh 6.18.2-1.0.0"
    echo "Example: ./docker-run.sh 6.18.2-1.0.0 yocto-build.sh"
    echo ""
    echo "Available versions:"
    grep -v "^#" versions.txt | grep -v "^$" | awk '{printf "  %-20s Ubuntu %-6s %s\n", $1, $2, $3}'
    exit 0
fi

INPUT_VERSION=$1
COMMAND=${2:-bash}

# Parse version config
parse_version_config "$INPUT_VERSION"
if [ $? -ne 0 ]; then
    echo "Failed to parse version configuration"
    exit 1
fi

# Set TAG and IMX_RELEASE after parsing
TAG="imx-docker:imx-${VERSION}"
IMX_RELEASE="imx-${VERSION}"

echo "Running container for i.MX ${VERSION}"
echo "  Tag:      ${TAG}"
echo "  Branch:   ${BRANCH}"
echo "  Manifest: ${MANIFEST}"
echo "  Machine:  ${MACHINE}"
echo "  Distro:   ${DISTRO}"
echo "  Images:   ${IMAGES}"
echo ""

# Build volume mount arguments for SSH and Git config if they exist
VOLUME_MOUNTS="--volume ${DOCKER_WORKDIR}:${DOCKER_WORKDIR}"

if [ -d "${HOME}/.ssh" ]; then
    VOLUME_MOUNTS="${VOLUME_MOUNTS} --volume ${HOME}/.ssh:${HOME}/.ssh:ro"
fi

if [ -f "${HOME}/.gitconfig" ]; then
    VOLUME_MOUNTS="${VOLUME_MOUNTS} --volume ${HOME}/.gitconfig:${HOME}/.gitconfig:ro"
fi

# Pass configuration as environment variables to container
docker run -it --rm \
    ${VOLUME_MOUNTS} \
    --env VERSION=${VERSION} \
    --env BRANCH=${BRANCH} \
    --env MANIFEST=${MANIFEST} \
    --env MACHINE=${MACHINE} \
    --env DISTRO=${DISTRO} \
    --env IMAGES=${IMAGES} \
    --env REMOTE=${REMOTE} \
    --env DOCKER_WORKDIR=${DOCKER_WORKDIR} \
    ${TAG} \
    ${COMMAND}
