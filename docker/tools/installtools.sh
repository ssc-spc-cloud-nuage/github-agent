#!/bin/bash -e

SCRIPT_PATH=$(realpath "$0" | sed 's|\(.*\)/.*|\1|')

export HELPER_SCRIPTS="${SCRIPT_PATH}/helpers"

for f in "${SCRIPT_PATH}"/base/*.sh; do
    if ! bash "$f" -H; then
        echo "Failed to install ${f}"
        exit 1;
    fi
done

for f in "${SCRIPT_PATH}"/install/*.sh; do
    if ! bash "$f" -H; then 
        echo "Failed to install ${f}"
        exit 1;
    fi
done