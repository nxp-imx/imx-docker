#!/bin/bash
#
# This script creates the yocto-ready docker image.
# The --build-arg options are used to pass data about the current user.
# Also, a tag is used for easy identification of the generated image.
#

# source the common variables
. ./env.sh

usage() {
    echo -e "\e[3m\nUsage: $0 [path_to_Dockerfile]\e[0m\n"
}

# main

if [ $# -ne 1 ]
    then
        usage
    else
        docker build --tag "${DOCKER_IMAGE_TAG}" \
                     --build-arg "DOCKER_WORKDIR=${DOCKER_WORKDIR}" \
                     --build-arg "USER=$(whoami)" \
                     --build-arg "host_uid=$(id -u)" \
                     --build-arg "host_gid=$(id -g)" \
					 --network host \
                     -f $1 \
                     .
fi
