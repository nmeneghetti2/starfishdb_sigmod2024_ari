#!/bin/bash

# Script to compile all .sh files in the current directory into a single text file
# Usage: ./compile_scripts.sh
# Output: scripts_compilation.txt

# Output file name
output_file="scripts_compilation.txt"

# Clear or create the output file
> "$output_file"

# Add header to the file
echo "Shell Scripts Compilation" > "$output_file"
echo "Generated on: $(date)" >> "$output_file"
echo "----------------------------------------" >> "$output_file"

# Counter for found files
count=0

# Find all .sh files in current directory (excluding this script itself)
for script in *.sh; do
    # Skip if no .sh files are found
    if [ "$script" = "*.sh" ]; then
        echo "No shell scripts found in current directory."
        exit 1
    fi
    
    # Skip this script itself
    if [ "$script" = "$(basename "$0")" ]; then
        continue
    fi
    
    # Increment counter
    ((count++))
    
    # Add file header
    echo -e "\n### File: $script ###" >> "$output_file"
    echo "----------------------------------------" >> "$output_file"
    
    # Add file contents
    cat "$script" >> "$output_file"
    echo -e "\n----------------------------------------\n" >> "$output_file"
done

# Add summary
echo -e "\nCompilation Summary:" >> "$output_file"
echo "Total scripts compiled: $count" >> "$output_file"

echo "Compilation complete. Output saved to $output_file"
echo "Total scripts processed: $count"