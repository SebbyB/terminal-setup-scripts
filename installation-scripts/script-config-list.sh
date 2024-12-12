#!/bin/bash
# -------------------------------------------------------------------------------
# Script Name:  script-config-list.sh
# Description:  This will take a text file of shell script paths and runs 
# 	them for configuration or installation.
#
#       Proceed with Caution!
#       This program does not validate the scripts it is running. 
#       Do not run scripts for a source you don't trust or understand!
#       You are solely responsible for bricking your install
#       with a faulty list!!
# Author:       Sebastian Barney
# Created on:   12-12-24
# Updated on:   12-12-24
# Version:      1.0
# Usage:        ./script-config-list.sh <file_with_shell_script_paths>
#
#       bash "$THIS_SHELL_SCRIPT" $"FILE_VAR"
# -------------------------------------------------------------------------------

# Ensure a file is passed as a parameter
if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <scripts_list_file>"
  exit 1
fi

SCRIPTS_LIST="$1"

# Ensure the file exists
if [[ ! -f "$SCRIPTS_LIST" ]]; then
  echo "Error: File '$SCRIPTS_LIST' not found!"
  exit 1
fi

# Print the working directory for debugging
echo "Current working directory: $(pwd)"
echo "Processing scripts from: $SCRIPTS_LIST"

# Loop through each script path in the file
while IFS= read -r script_path; do
  if [[ -n "$script_path" ]]; then
    # Resolve the absolute path
    abs_script_path=$(realpath "$script_path" 2>/dev/null || echo "$script_path")

    echo "Executing script: $abs_script_path"

    # Ensure the script exists and is executable
    if [[ -f "$abs_script_path" && -x "$abs_script_path" ]]; then
      "$abs_script_path" || echo "Failed to execute $abs_script_path"
    else
      echo "Error: $abs_script_path does not exist or is not executable"
    fi
  fi
done < "$SCRIPTS_LIST"

echo "All scripts processed."

