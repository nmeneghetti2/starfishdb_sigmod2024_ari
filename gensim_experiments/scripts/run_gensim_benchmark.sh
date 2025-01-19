#!/bin/bash

# Determine the project's root directory
PROJECT_ROOT_ABS_PATH=$(readlink -f "$(dirname "$0")/..")

# Set the scripts directory
SCRIPTS_ABS_PATH=$(readlink -f "${PROJECT_ROOT_ABS_PATH}/scripts")

# Set the path to the run_gensim.sh script
RUN_GENSIM_SCRIPT="${SCRIPTS_ABS_PATH}/run_gensim.sh"

# Parse command line arguments
TEST_MODE=false
while getopts "t" opt; do
  case $opt in
    t)
      TEST_MODE=true
      echo "Running in test mode - will only process KOS dataset"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

# Check if the run_gensim.sh script exists
if [ ! -f "$RUN_GENSIM_SCRIPT" ]; then
    echo "Error: $RUN_GENSIM_SCRIPT not found!"
    exit 1
fi

# Make sure the script is executable
chmod +x "$RUN_GENSIM_SCRIPT"

# Set the logs directory
LOGS_ABS_PATH=$(readlink -f "${PROJECT_ROOT_ABS_PATH}/logs")

# Create the logs directory if it doesn't exist
mkdir -p "$LOGS_ABS_PATH"

# Set the log file path
LOG_FILE="${LOGS_ABS_PATH}/gensim_benchmark_$(date +%Y%m%d_%H%M%S).log"

# Array of datasets - if test mode, only include KOS
if [ "$TEST_MODE" = true ]; then
    DATASETS=("KOS")
else
    DATASETS=("KOS" "NYTIMES" "PUBMED")
fi

# Function to run the script, log output, and measure time
run_and_log() {
    local dataset=$1
    local start_time=$(date +%s)
    
    echo "Running LDA for dataset: $dataset" | tee -a "$LOG_FILE"
    echo "Start time: $(date)" | tee -a "$LOG_FILE"
    
    "$RUN_GENSIM_SCRIPT" -d "$dataset" 2>&1 | tee -a "$LOG_FILE"
    
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    echo "Finished processing $dataset" | tee -a "$LOG_FILE"
    echo "End time: $(date)" | tee -a "$LOG_FILE"
    echo "Time taken for $dataset: $duration seconds" | tee -a "$LOG_FILE"
    echo "----------------------------------------" | tee -a "$LOG_FILE"
}

# Main execution
{
    echo "Starting Gensim benchmark at $(date)"
    if [ "$TEST_MODE" = true ]; then
        echo "Running in test mode with KOS dataset only"
    fi
    echo "Project root: $PROJECT_ROOT_ABS_PATH"
    echo "Scripts directory: $SCRIPTS_ABS_PATH"
    echo "Log file: $LOG_FILE"
    echo "----------------------------------------"

    # Loop through each dataset and run the script
    for dataset in "${DATASETS[@]}"; do
        run_and_log "$dataset"
    done

    echo "All datasets have been processed."
    if [ "$TEST_MODE" = true ]; then
        echo "Test mode completed successfully with KOS dataset"
    fi
    echo "Gensim benchmark completed at $(date)"
} 2>&1 | tee -a "$LOG_FILE"

echo "Log file has been saved to: $LOG_FILE"