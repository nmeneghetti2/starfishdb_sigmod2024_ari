#!/bin/bash

# on failure, terminate the script immediately
set -e

# determine original username 
ORIG_USER=${SUDO_USER-${USER}}

# Determine the script's absolute path
SCRIPTSDIR_ABS_PATH=$(readlink -f "${BASH_SOURCE[0]}")
SCRIPTSDIR_ABS_PATH=$(dirname "${SCRIPTSDIR_ABS_PATH}")

# Determine the project's root path
PROJECT_ROOT_ABS_PATH=$(readlink -f "${SCRIPTSDIR_ABS_PATH}/../")
PROJECT_ROOT_ABS_PATH_HASH=$(echo "${PROJECT_ROOT_ABS_PATH}" | md5sum | cut -d' ' -f 1 | cut -c 25-32) 

# Determine commonly used directories
DATADIR_ABS_PATH=$(readlink -f "${PROJECT_ROOT_ABS_PATH}/data")

# Define shared data directory on host - now at project root level
SHARED_DATA_DIR="${PROJECT_ROOT_ABS_PATH}/../shared/lda_datasets"

# Ensure the shared data directory exists
mkdir -p "${SHARED_DATA_DIR}"

# Define container name and mount options
DOCKER_IMG_NAME="gensim_lda_centos7_docker_img" 
DOCKER_CONT_NAME="gensim_lda_container_${ORIG_USER}${PROJECT_ROOT_ABS_PATH_HASH}"
MOUNT_OPTIONS="${PROJECT_ROOT_ABS_PATH}:/app:Z ${SHARED_DATA_DIR}:/app/data:Z"

echo "Mount options: ${MOUNT_OPTIONS}"
echo "Container name: ${DOCKER_CONT_NAME}"

# Run container with mounted volumes
docker run -v "${PROJECT_ROOT_ABS_PATH}:/app:Z" -v "${SHARED_DATA_DIR}:/app/data:Z" \
    --name "${DOCKER_CONT_NAME}" \
    --detach --tty "${DOCKER_IMG_NAME}" /bin/bash

echo "Or run \"docker exec -it ${DOCKER_CONT_NAME} bash\" to access the container."