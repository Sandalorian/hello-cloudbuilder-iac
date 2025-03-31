#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to display usage information
usage() {
    echo "Usage: $0 <TEMPLATE_FILE> <OUTPUT_FILE> <PIPELINE_CONFIG_DIR> <GH_COMMIT_SHA> <PIPELINE_TYPE>"
    exit 1
}

# Ensure all required arguments are provided
if [[ $# -ne 5 ]]; then
    usage
fi

# Assign command-line arguments to variables
TEMPLATE_FILE="$1"
OUTPUT_FILE="$2"
PIPELINE_CONFIG_DIR="$3"
GH_COMMIT_SHA="$4"
PIPELINE_TYPE="$5"

# Ensure the template file exists
if [[ ! -f "$TEMPLATE_FILE" ]]; then
    echo "Error: Template file '$TEMPLATE_FILE' not found."
    exit 1
fi

# Ensure the pipeline config directory exists and is a directory
if [[ ! -d "$PIPELINE_CONFIG_DIR" ]]; then
    echo "Error: Pipeline config directory '$PIPELINE_CONFIG_DIR' not found or is not a directory."
    exit 1
fi

# Get all files in the pipeline config directory, sorted alphabetically
CONFIG_FILES=$(find "$PIPELINE_CONFIG_DIR" -type f | sort)

# Ensure there are files in the directory
if [[ -z "$CONFIG_FILES" ]]; then
    echo "Error: No config files found in '$PIPELINE_CONFIG_DIR'."
    exit 1
fi

# Step 1: Replace placeholders in the template file
sed -e "s/COMMIT_SHA/\"${GH_COMMIT_SHA}\"/g" \
    -e "s/PIPELINE_TYPE/${PIPELINE_TYPE}/g" "$TEMPLATE_FILE" |

# Step 2: Insert concatenated pipeline config files where PIPELINE_CONFIG is found
awk -v config_dir="$PIPELINE_CONFIG_DIR" '
/PIPELINE_CONFIG/ {
    system("cat " config_dir "/* | sed \"s/^/        /\"");
    next
}
{ print }
' > "$OUTPUT_FILE"

# Print success message
echo "Pipeline file generated: $OUTPUT_FILE"
