
#!/bin/bash

# on failure, terminate the script immediately
set -e

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
REPORT_ABS_PATH=$(readlink -f ${PROJECT_ROOT_ABS_PATH}/report)
LOGS_ABS_PATH=$(readlink -f ${PROJECT_ROOT_ABS_PATH}/logs)

# saving current working directory
cwd=$(pwd)

# make sure this is run with sudo
if [ "$EUID" -ne 0 ]
  then echo "ERROR: please run this script as root"
  exit 77
fi



echo "-----------------------------------------------" >> ${LOGS_ABS_PATH}/benchmark_dir_content.txt
# uname -n 2>&1 | tee -a ${LOGS_ABS_PATH}/benchmark_dir_content.txt
# hostname -f 2>&1 | tee -a ${LOGS_ABS_PATH}/benchmark_dir_content.txt
date +"Date : %d/%m/%Y Time : %H.%M.%S" >> ${LOGS_ABS_PATH}/benchmark_dir_content.txt
echo "-----------------------------------------------" >> ${LOGS_ABS_PATH}/benchmark_dir_content.txt
echo "find -type f | sort | xargs ls -l" >> ${LOGS_ABS_PATH}/benchmark_dir_content.txt

cd ${BENCHMARKSDIR_ABS_PATH}
find -type f | sort | xargs ls -l 2>&1 | tee -a ${LOGS_ABS_PATH}/benchmark_dir_content.txt

echo "find -type f | sort | xargs md5sum" >> ${LOGS_ABS_PATH}/benchmark_dir_content.txt
find -type f | sort | xargs md5sum 2>&1 | tee -a ${LOGS_ABS_PATH}/benchmark_dir_content.txt

echo "*" >> ${LOGS_ABS_PATH}/benchmark_dir_content.txt
echo "*" >> ${LOGS_ABS_PATH}/benchmark_dir_content.txt
echo "*" >> ${LOGS_ABS_PATH}/benchmark_dir_content.txt

# restoring original working directory
cd ${cwd}
