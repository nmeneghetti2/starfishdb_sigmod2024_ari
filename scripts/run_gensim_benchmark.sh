#!/bin/bash

# Set environment variables for data locations
export SHARED_DATA_DIR="/app/shared/lda_datasets"
export DATA_DIR="/data"
TESTSET_DIR="${DATA_DIR}/${DATASET_NAME}_test/mallet"
TRAININGSET_DIR="${DATA_DIR}/${DATASET_NAME}_train/mallet"

# Get the absolute path of the scripts directory
SCRIPTS_ABS_PATH=$(dirname $(readlink -f "$0"))

# Create a temporary copy of the Python script
TEMP_SCRIPT="/tmp/gensim_lda_test_modified.py"
cp "${SCRIPTS_ABS_PATH}/gensim_lda_test.py" "${TEMP_SCRIPT}"

# Verify data structure
echo "Verifying data directory structure..."
for dataset in "KOS" "NYTIMES" "PUBMED"; do
    for split in "train" "test"; do
        base_dir="/app/shared/lda_datasets/${dataset}_${split}"
        csv2_dir="${base_dir}/csv2"
        data_file="${csv2_dir}/${dataset}_${split}.csv"
        vocab_file="${csv2_dir}/${dataset}_vocab.csv"
        
        echo "Checking ${dataset}_${split}..."
        echo "  Base directory: ${base_dir}"
        if [ -d "$base_dir" ]; then
            echo "    ✓ Base directory exists"
            if [ -d "$csv2_dir" ]; then
                echo "    ✓ CSV2 directory exists"
                if [ -f "$data_file" ]; then
                    echo "    ✓ Data file exists"
                else
                    echo "    ✗ Data file missing: $data_file"
                    exit 1
                fi
                if [ -f "$vocab_file" ]; then
                    echo "    ✓ Vocab file exists"
                else
                    echo "    ✗ Vocab file missing: $vocab_file"
                    exit 1
                fi
            else
                echo "    ✗ CSV2 directory missing: $csv2_dir"
                exit 1
            fi
        else
            echo "    ✗ Base directory missing: $base_dir"
            exit 1
        fi
    done
done
echo "Data verification complete."

# Create log directory if it doesn't exist
mkdir -p /app/logs
LOG_FILE="/app/logs/gensim_benchmark_$(date +%Y%m%d_%H%M%S).log"

# Main execution
{
    echo "Starting Gensim benchmark at $(date)"
    echo "Project root: $PROJECT_ROOT_ABS_PATH"
    echo "Scripts directory: $SCRIPTS_ABS_PATH"
    echo "Log file: $LOG_FILE"
    echo "----------------------------------------"

    # Run for each dataset
    for dataset in "KOS" "NYTIMES" "PUBMED"; do
        echo "Running LDA for dataset: $dataset" | tee -a "$LOG_FILE"
        echo "Start time: $(date)" | tee -a "$LOG_FILE"
        
        # Use the temporary script
        python3 "${TEMP_SCRIPT}" -d "$dataset" 2>&1 | tee -a "$LOG_FILE"
        
        echo "Finished processing $dataset" | tee -a "$LOG_FILE"
        echo "End time: $(date)" | tee -a "$LOG_FILE"
        echo "----------------------------------------" | tee -a "$LOG_FILE"
    done

    echo "All datasets have been processed."
    echo "Gensim benchmark completed at $(date)"
    echo "Log file has been saved to: $LOG_FILE"
} 2>&1 | tee -a "$LOG_FILE"

# Clean up
rm -f "${TEMP_SCRIPT}" 

# Update file paths for CSV reading
TRAIN_CSV="${DATA_DIR}/${DATASET_NAME}_train/csv2/${DATASET_NAME}_train.csv"
TEST_CSV="${DATA_DIR}/${DATASET_NAME}_test/csv2/${DATASET_NAME}_test.csv"
TRAIN_TSV="${DATA_DIR}/${DATASET_NAME}_train/tsv/training.tsv"
TEST_TSV="${DATA_DIR}/${DATASET_NAME}_test/tsv/test.tsv"
VOCAB_CSV="${DATA_DIR}/${DATASET_NAME}_train/csv2/${DATASET_NAME}_vocab.csv" 