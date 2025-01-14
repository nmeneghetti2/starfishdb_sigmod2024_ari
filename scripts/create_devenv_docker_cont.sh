#!/bin/bash

# on failure, terminate the script immediately
set -e

# determine original username 
# (in a sudo session, this returns the user that originally invoked sudo,
# in a regular user-land session, this retuns the regula ${USER})
ORIG_USER=${SUDO_USER-${USER}}

# Determine the script's absolute path
SCRIPTSDIR_ABS_PATH=$(readlink -f ${BASH_SOURCE[0]})
SCRIPTSDIR_ABS_PATH=$(dirname ${SCRIPTSDIR_ABS_PATH})

# Determine the project's root path
PROJECT_ROOT_ABS_PATH=$(readlink -f ${SCRIPTSDIR_ABS_PATH}/../)
PROJECT_ROOT_ABS_PATH_HASH=$(echo ${PROJECT_ROOT_ABS_PATH} | md5sum | cut -d' ' -f 1 | cut -c 25-32) 

# Define shared data directory - same location as used by gensim container
SHARED_DATA_DIR=$(readlink -f "${PROJECT_ROOT_ABS_PATH}/shared/lda_datasets")

# Ensure the shared data directory exists
mkdir -p "${SHARED_DATA_DIR}"

# Debug output
echo "Project root: ${PROJECT_ROOT_ABS_PATH}"
echo "Shared data directory: ${SHARED_DATA_DIR}"
ls -la "${SHARED_DATA_DIR}" || echo "Warning: Cannot access ${SHARED_DATA_DIR}"

# Determine commonly used directories
EXTERNALTOOLS_ABS_PATH=$(readlink -f ${PROJECT_ROOT_ABS_PATH}/external)
EXTERNALLIBS_ABS_PATH=$(readlink -f ${PROJECT_ROOT_ABS_PATH}/libs)
PATCHESDIR_ABS_PATH=$(readlink -f ${PROJECT_ROOT_ABS_PATH}/patches)
BUILDDIR_ABS_PATH=$(readlink -f ${PROJECT_ROOT_ABS_PATH}/build)
DATADIR_ABS_PATH=$(readlink -f ${PROJECT_ROOT_ABS_PATH}/data)
CONFDIR_ABS_PATH=$(readlink -f ${PROJECT_ROOT_ABS_PATH}/conf)
EXTRASDIR_ABS_PATH=$(readlink -f ${PROJECT_ROOT_ABS_PATH}/extras)
BENCHMARKSDIR_ABS_PATH=$(readlink -f ${PROJECT_ROOT_ABS_PATH}/benchmarks)

# Relocate <root>/data, if necessary
if [ $(grep -c "^[^#]" $CONFDIR_ABS_PATH/datadir_redirect.txt) != "0" ]; then
  mkdir -p $(grep "^[^#]" $CONFDIR_ABS_PATH/datadir_redirect.txt | head -n 1)
  DATADIR_ABS_PATH=$(readlink -f $(grep "^[^#]" ${CONFDIR_ABS_PATH}/datadir_redirect.txt | head -n 1))
  echo "NOTICE: <root>/data directory was relocated to ${DATADIR_ABS_PATH}"
fi


# make sure this is run with sudo
#if [ "$EUID" -ne 0 ]
#  then echo "WARNING: You probably want to run this as root"
#fi




DISTRO="devenv"


# define the image's name
DOCKER_IMG_NAME="starfishdb_dev_env_docker_img" 
DOCKER_CONT_NAME="starfishdb_dev_env_container_${ORIG_USER}${PROJECT_ROOT_ABS_PATH_HASH}"
#MOUNT_OPTIONS="type=bind,source=${PROJECT_ROOT_ABS_PATH},target=/gammapdb_arrow"
MOUNT_OPTIONS="${PROJECT_ROOT_ABS_PATH}:/gammapdb_arrow:z ${SHARED_DATA_DIR}:/gammapdb_arrow/data:z"

echo "Mount options: ${MOUNT_OPTIONS}"
echo "Container name: ${DOCKER_CONT_NAME}"

docker run -v "${PROJECT_ROOT_ABS_PATH}:/gammapdb_arrow:z" -v "${SHARED_DATA_DIR}:/gammapdb_arrow/data:z" \
    --name "${DOCKER_CONT_NAME}" \
    --detach --tty "${DOCKER_IMG_NAME}" /bin/bash

echo "Run \"docker exec -it ${DOCKER_CONT_NAME} bash\" to access the container."



