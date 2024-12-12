#!/bin/bash
# -------------------------------------------------------------------------------
# Script Name:  curl-install-list.sh
# Description:  This will take a text file of URLs and install packages via curl.
#       Proceed with Caution!
#       This program does not validate URL or package compatibility.
#       You are solely responsible for bricking your install
#       with a faulty list!!
# Author:       Sebastian Barney
# Created on:   2024-12-12
# Updated on:   2024-12-12
# Version:      1.0
# Usage:        ./curl-install-list.sh <file_with_urls>
#
#       bash "$THIS_SHELL_SCRIPT" $"FILE_VAR"
# -------------------------------------------------------------------------------

# Ensure a file is passed as a parameter
if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <url_list_file>"
  exit 1
fi

URL_LIST="$1"

# Ensure the file exists
if [[ ! -f "$URL_LIST" ]]; then
  echo "Error: File '$URL_LIST' not found!"
  exit 1
fi

# Loop through each URL in the file
while IFS= read -r url; do
	if [[ -n "$url" ]]; then
    		echo "Downloading and installing from $url"
    		# Download the file
    		filename=$(basename "$url")
		curl -LO "$url"
	fi
done < "$URL_LIST"

echo "All programs processed."

