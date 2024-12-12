#!/bin/bash
# -------------------------------------------------------------------------------
# Script Name:  apt-install-list.sh
# Description:  This will take a text file of packages and install them via apt.
# 		Proceed withCaution! 
# 		This program does not validate package compatibility.
#		You are solely responsible for bricking your installl 
#		with a faulty list!!
# Author:       Sebastian Barney
# Created on:   2024-12-12
# Updated on:   2024-12-12
# Version:      1.0
# Usage:        ./apt-install-list.sh <file_with_programs>
#
#		bash "$THIS_SHELL_SCRIPT" $"FILE_VAR"
# -------------------------------------------------------------------------------

# Check if a file is passed as an argument
if [[ $# -ne 1 || ! -f $1 ]]; then
    echo "Usage: $0 <file_with_programs>"
    exit 1
fi

# Read programs from the file
programs=$(cat "$1")

# Update and install programs
echo "Updating package list..."
sudo apt update -y

echo "Installing programs..."
while IFS= read -r program; do
    if ! dpkg -l | grep -qw "$program"; then
        echo "Installing $program..."
        sudo apt install -y "$program"
    else
        echo "$program is already installed."
    fi
done <<< "$programs"

echo "Installation complete."
