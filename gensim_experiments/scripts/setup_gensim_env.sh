#!/bin/bash

# Get the script's directory
SCRIPTSDIR_ABS_PATH=$(readlink -f "${BASH_SOURCE[0]}")
SCRIPTSDIR_ABS_PATH=$(dirname "${SCRIPTSDIR_ABS_PATH}")
PROJECT_ROOT_ABS_PATH=$(readlink -f "${SCRIPTSDIR_ABS_PATH}/../../")

# Create conf directory if it doesn't exist
mkdir -p "${SCRIPTSDIR_ABS_PATH}/../conf"

# Copy necessary config files from main project
cp "${PROJECT_ROOT_ABS_PATH}/conf/datadir_redirect.txt" "${SCRIPTSDIR_ABS_PATH}/../conf/"
cp "${PROJECT_ROOT_ABS_PATH}/conf/uci_datasets.txt" "${SCRIPTSDIR_ABS_PATH}/../conf/"
cp "${PROJECT_ROOT_ABS_PATH}/conf/checksums.sha256" "${SCRIPTSDIR_ABS_PATH}/../conf/"

echo "Configuration files copied successfully" 