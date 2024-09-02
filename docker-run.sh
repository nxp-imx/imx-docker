#!/bin/bash
#
# This script runs the image generated by the docker build script
# using docker run command, where:
#   --rm  automatically removes the container and on exit
#   -i  keeps the standard input open
#   -t  provides a terminal as a interactive shell within container
#   --volumes  are file systems mounted on docker container to preserve
# data generated during the yocto build and these are stored on the host.
# Left side being an absolute path on the host machine, right side being
# an absolute path inside the container.
#
# The script can be run with or without parameter:
#
#   $ ./docker-run.sh
#
# to go into docker container prompt or:
#
#   $ ./docker-run.sh ${IMX_RELEASE}/yocto-build.sh
#
# to run yocto-build script inside container
#

# source the common variables
. ./env.sh

# avoid docker creating this dir as root
mkdir -p "$DOCKER_WORKDIR"

# run the docker image
docker run -it --rm \
    --volume ${DOCKER_WORKDIR}:/opt/yocto/ \
    --volume $(pwd)/${IMX_RELEASE}${IMX_RELEASE_VARIANT}:/opt/yocto/${IMX_RELEASE} \
    "${DOCKER_IMAGE_TAG}" \
    $1
