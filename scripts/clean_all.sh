#!/bin/bash

# Determine the script's absolute path
SCRIPTSDIR_ABS_PATH=$(readlink -f ${BASH_SOURCE[0]})
SCRIPTSDIR_ABS_PATH=$(dirname ${SCRIPTSDIR_ABS_PATH})

# Determine the project's root path
PROJECT_ROOT_ABS_PATH=$(readlink -f ${SCRIPTSDIR_ABS_PATH}/../)

# Determine commonly used directories
EXTERNALTOOLS_ABS_PATH=$(readlink -f ${PROJECT_ROOT_ABS_PATH}/external)
EXTERNALLIBS_ABS_PATH=$(readlink -f ${PROJECT_ROOT_ABS_PATH}/libs)
PATCHESDIR_ABS_PATH=$(readlink -f ${PROJECT_ROOT_ABS_PATH}/patches)
BUILDDIR_ABS_PATH=$(readlink -f ${PROJECT_ROOT_ABS_PATH}/build)
DATADIR_ABS_PATH=$(readlink -f ${PROJECT_ROOT_ABS_PATH}/data)
CONFDIR_ABS_PATH=$(readlink -f ${PROJECT_ROOT_ABS_PATH}/conf)
EXTRASDIR_ABS_PATH=$(readlink -f ${PROJECT_ROOT_ABS_PATH}/extras)
BENCHMARKSDIR_ABS_PATH=$(readlink -f ${PROJECT_ROOT_ABS_PATH}/benchmarks)
LOGS_ABS_PATH=$(readlink -f ${PROJECT_ROOT_ABS_PATH}/logs)

# Relocate <root>/data, if necessary
if [ $(grep -c "^[^#]" $CONFDIR_ABS_PATH/datadir_redirect.txt) != "0" ]; then
  mkdir -p $(grep "^[^#]" $CONFDIR_ABS_PATH/datadir_redirect.txt | head -n 1)
  DATADIR_ABS_PATH=$(readlink -f $(grep "^[^#]" ${CONFDIR_ABS_PATH}/datadir_redirect.txt | head -n 1))
  echo "NOTICE: <root>/data directory was relocated to ${DATADIR_ABS_PATH}"
fi


rm -rf ${BENCHMARKSDIR_ABS_PATH}/gammapdb_data/lda-inmemory-vrexpr/chain_states/*
rm -rf ${BENCHMARKSDIR_ABS_PATH}/gammapdb_data/lda-inmemory-vrexpr/evaluators/*


rm -rf ${BENCHMARKSDIR_ABS_PATH}/gammapdb_data/lda-inmemory-vrexprP/chain_states/*
rm -rf ${BENCHMARKSDIR_ABS_PATH}/gammapdb_data/lda-inmemory-vrexprP/evaluators/*


rm -rf ${BENCHMARKSDIR_ABS_PATH}/mallet_data/chain_states/*
rm -rf ${BENCHMARKSDIR_ABS_PATH}/mallet_data/evaluators/*

rm -rf ${LOGS_ABS_PATH}/log_run_lda_benchmarksP100.txt
rm -rf ${LOGS_ABS_PATH}/log_run_lda_benchmarksP50.txt
rm -rf ${LOGS_ABS_PATH}/log_run_lda_benchmarks.txt







