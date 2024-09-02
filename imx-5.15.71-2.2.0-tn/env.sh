#!/bin/bash
# Here are some default settings.
# Make sure DOCKER_WORKDIR is created and owned by current user.

# Docker

DOCKER_IMAGE_TAG="imx-yocto"
DOCKER_WORKDIR="/opt/yocto"

# Yocto

IMX_RELEASE="imx-5.15.71-2.2.0"
IMX_RELEASE_VARIANT="-tn"

YOCTO_DIR="${DOCKER_WORKDIR}/${IMX_RELEASE}-build"

MACHINE="edm-g-imx8mp"
DISTRO="imx-desktop-xwayland"
IMAGES="imx-image-desktop"

REMOTE="https://github.com/TechNexion/tn-imx-yocto-manifest"
BRANCH="kirkstone_5.15.y-stable"
MANIFEST=${IMX_RELEASE}".xml"
