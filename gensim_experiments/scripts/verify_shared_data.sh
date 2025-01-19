#!/bin/bash

# Check if shared data directory exists and has required datasets
SHARED_DATA_DIR="/data"

verify_dataset() {
    local dataset=$1
    if [ ! -d "${SHARED_DATA_DIR}/${dataset}_train" ]; then
        echo "ERROR: ${dataset} dataset not found in shared directory"
        echo "Please run get_uci_datasets.sh first to download and process the data"
        exit 1
    fi
}

# Verify shared directory exists
if [ ! -d "$SHARED_DATA_DIR" ]; then
    echo "ERROR: Shared data directory not found at ${SHARED_DATA_DIR}"
    echo "Please create the directory and run get_uci_datasets.sh first"
    exit 1
fi

# Verify required datasets exist
verify_dataset "KOS"
verify_dataset "NYTIMES"
verify_dataset "PUBMED"

# Verify raw UCI data exists
if [ ! -d "${SHARED_DATA_DIR}/raw/uci" ]; then
    echo "ERROR: Raw UCI data not found in shared directory"
    echo "Please run get_uci_datasets.sh first to download the data"
    exit 1
fi

echo "All required datasets found in shared directory" 