#!/bin/bash
# This script will run into container

# source the common variables
. imx-5.15.71-2.2.2/env.sh

#

mkdir -p ${YOCTO_DIR}
cd ${YOCTO_DIR}

# Init

repo init \
    -u ${REMOTE} \
    -b ${BRANCH} \
    -m ${MANIFEST}

repo sync -j`nproc`

# source the yocto env

EULA=1 MACHINE="${MACHINE}" DISTRO="${DISTRO}" source tn-setup-release.sh -b build-${DISTRO}

# Build

bitbake ${IMAGES}

