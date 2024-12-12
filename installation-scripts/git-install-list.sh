#!/bin/bash
# -------------------------------------------------------------------------------
# Script Name:  git-install-list.sh
# Description:  This will take a text file of Git repositories and clone them
# 	in an install path dir. There is an optional true/false flag which will
# 	run the installation scripts provided by the git repo. 
# 	It is set to true by default.
#
# 	Git should be configured with correct authorization for repos that are
# 	listed as private. 
# 	If you have not set this up via something such as ssh, 
# 	it will not install your repo if it is private. 
#
#       Proceed with Caution!
#       This program does not validate repository availability.
#       You are solely responsible for bricking your install
#       with a faulty list!!
# Author:       Sebastian Barney
# Created on:   12-12-24
# Updated on:   12-12-24
# Version:      1.0
# Usage:        ./git-install-list.sh <file_with_repositories> <install_path> [run_install_scripts (true|false)]"
#
#       bash "$THIS_SHELL_SCRIPT" $"FILE_VAR" "(true|false)"
# -------------------------------------------------------------------------------


# Ensure at least two arguments are provided
if [[ $# -lt 2 || $# -gt 3 ]]; then
  echo "Usage: $0 <repo_list_file> <install_path> [run_install_scripts (true|false)]"
  exit 1
fi

# Arguments
REPO_LIST="$1"
INSTALL_PATH="$2"
RUN_INSTALL_SCRIPTS="${3:-true}" # Default to true if not specified

# Ensure the list file exists
if [[ ! -f "$REPO_LIST" ]]; then
  echo "Error: File '$REPO_LIST' not found!"
  exit 1
fi

# Create the installation directory if it doesn't exist
mkdir -p "$INSTALL_PATH"

# Loop through each repository URL in the file
while IFS= read -r repo_url; do
  if [[ -n "$repo_url" ]]; then
    echo "Cloning repository: $repo_url"

    # Extract the repository name
    repo_name=$(basename "$repo_url" .git)
    target_dir="$INSTALL_PATH/$repo_name"

    # Clone the repository
    git clone "$repo_url" "$target_dir" || {
      echo "Failed to clone $repo_url"
      continue
    }

    # Run the install script if specified and the script exists
    if [[ "$RUN_INSTALL_SCRIPTS" == "true" && -f "$target_dir/install.sh" ]]; then
      echo "Running install script for $repo_name"
      chmod +x "$target_dir/install.sh"
      "$target_dir/install.sh" || echo "Failed to execute install script for $repo_name"
    elif [[ "$RUN_INSTALL_SCRIPTS" == "false" ]]; then
      echo "Skipping install script for $repo_name"
    else
      echo "No install script found for $repo_name"
    fi
  fi
done < "$REPO_LIST"

echo "All repositories processed."

