#!/bin/sh
set -e

HOST_UID="$1"
HOST_GID="$2"
USER_NAME="$3"

# Ensure group exists with desired GID and name
if ! getent group "${HOST_GID}" >/dev/null; then
    groupadd -g "${HOST_GID}" "${USER_NAME}"
else
    existing_group="$(getent group "${HOST_GID}" | cut -d: -f1)"
    if [ "${existing_group}" != "${USER_NAME}" ]; then
        groupmod -n "${USER_NAME}" "${existing_group}"
    fi
fi

# Ensure user exists with desired UID and name
if ! getent passwd "${HOST_UID}" >/dev/null; then
    useradd \
        -u "${HOST_UID}" \
        -g "${HOST_GID}" \
        -m \
        -s /bin/bash \
        "${USER_NAME}"
else
    existing_user="$(getent passwd "${HOST_UID}" | cut -d: -f1)"
    if [ "${existing_user}" != "${USER_NAME}" ]; then
        usermod -l "${USER_NAME}" "${existing_user}"
        usermod -d "/home/${USER_NAME}" -m "${USER_NAME}"
    fi
fi
