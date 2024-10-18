#!/bin/bash

# on failure, terminate the script immediately
set -e

# Determine the script's absolute path
SCRIPTSDIR_ABS_PATH=$(readlink -f ${BASH_SOURCE[0]})
SCRIPTSDIR_ABS_PATH=$(dirname ${SCRIPTSDIR_ABS_PATH})

# Determine the project's root path
PROJECT_ROOT_ABS_PATH=$(readlink -f ${SCRIPTSDIR_ABS_PATH}/../)

# Determine commonly used directories
DATADIR_ABS_PATH=$(readlink -f ${PROJECT_ROOT_ABS_PATH}/data)
CONFDIR_ABS_PATH=$(readlink -f ${PROJECT_ROOT_ABS_PATH}/conf)

# Relocate <root>/data, if necessary
if [ $(grep -c "^[^#]" $CONFDIR_ABS_PATH/datadir_redirect.txt) != "0" ]; then
  mkdir -p $(grep "^[^#]" $CONFDIR_ABS_PATH/datadir_redirect.txt | head -n 1)
  DATADIR_ABS_PATH=$(readlink -f $(grep "^[^#]" ${CONFDIR_ABS_PATH}/datadir_redirect.txt | head -n 1))
  echo "NOTICE: <root>/data directory was relocated to ${DATADIR_ABS_PATH}"
fi

# Function to remove UCI datasets
remove_uci_datasets() {
    if [ -d "${DATADIR_ABS_PATH}/raw/uci" ]; then
        echo "Removing UCI datasets directory..."
        rm -rf "${DATADIR_ABS_PATH}/raw/uci"
        echo "UCI datasets directory removed successfully."
    else
        echo "UCI datasets directory not found. Nothing to remove."
    fi
}

# Function to remove derived dataset files
remove_derived_datasets() {
    for dataset in KOS NYTIMES PUBMED; do
        if [ -d "${DATADIR_ABS_PATH}/${dataset}_train" ]; then
            echo "Removing ${dataset} training derived files..."
            rm -rf "${DATADIR_ABS_PATH}/${dataset}_train"
        fi
        if [ -d "${DATADIR_ABS_PATH}/${dataset}_test" ]; then
            echo "Removing ${dataset} test derived files..."
            rm -rf "${DATADIR_ABS_PATH}/${dataset}_test"
        fi
    done
    echo "Derived dataset files removed successfully."
}

# Main execution
echo "Starting UCI datasets recovery process..."

remove_uci_datasets
remove_derived_datasets

echo "Recovery process completed."
echo "We have removed the potentially corrupted datasets and derived files."
echo "You can now rerun ./get_uci_datasets.sh to download and process the datasets again."