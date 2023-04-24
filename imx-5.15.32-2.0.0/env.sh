#!/bin/bash
# Here are some default settings.
# Make sure DOCKER_WORKDIR is created and owned by current user.

# Docker

DOCKER_IMAGE_TAG="imx-yocto"
DOCKER_WORKDIR="/opt/yocto"

# Yocto

IMX_RELEASE="imx-5.15.32-2.0.0"

YOCTO_DIR="${DOCKER_WORKDIR}/${IMX_RELEASE}-build"

MACHINE="imx8mpevk"
DISTRO="fsl-imx-xwayland"
IMAGES="imx-image-core"

REMOTE="https://github.com/nxp-imx/imx-manifest"
BRANCH="imx-linux-kirkstone"
MANIFEST=${IMX_RELEASE}".xml"
