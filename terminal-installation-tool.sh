#!/bin/bash
# -------------------------------------------------------------------------------
# Script Name:  terminal-installation-tool.sh
# Description:  This will take a directory of lists to install packages via apt, 
# 	curl and git. It will also run what ever shell scripts you inject.
#
#       Proceed with Caution!
#       This program does not validate anything.
#       Do not run software you don't trust or understand!
#       You are solely responsible for bricking your install or losing data
#       with a faulty list or bad shell script!!
# Author:       Sebastian Barney
# Created on:   12-10-24
# Updated on:   12-12-24
# Version:      1.0
# Usage:        ./terminal-installation-tool.sh <>
#
#       bash "$THIS_SHELL_SCRIPT" $"DIR_VAR"
# -------------------------------------------------------------------------------

echo "Setting Up Terminal."



#Get the directory of the script
SCRIPT_DIR="$(dirname "$(realpath "$0")")"

#installation-scripts directory
INSTALL_SCRIPTS="$SCRIPT_DIR/installation-scripts"
echo "Scripts directory: $INSTALL_SCRIPTS"

#Directory Arg
if [ -d "$1" ]; then
    echo "The provided argument is a directory: $1"
else
    echo "Error: $1 is not a directory or does not exist."
    exit 1
fi

#installation-lists directory
#INSTALL_LISTS="$SCRIPT_DIR/installation-files"
INSTALL_LISTS="$1"
echo "Lists Directory: $INSTALL_LISTS"

#Repos Dir
REPOS=~/repositories
mkdir -p $REPOS

############################################################
#                       APT PROGRAMS                       #
############################################################

#Get the APT Install Script
APT_INSTALL_SCRIPT="$INSTALL_SCRIPTS/apt-install-list.sh"

#Check if the file exists
if [[ ! -f "$APT_INSTALL_SCRIPT" ]]; then
    echo "Error: File '$APT_INSTALL_SCRIPT' not found!" >&2
    exit 1
fi

#Get the APT Install List
APT_LIST="$INSTALL_LISTS/apt-list.txt"

if [[ ! -f "$APT_LIST" ]]; then
    echo "Error: File '$APT_LIST' not found!" >&2
    exit 1
fi

#Install apt packages.
echo "Installing APT Packages"
bash "$APT_INSTALL_SCRIPT" "$APT_LIST"


############################################################
#                       CURL PROGRAMS                      #
############################################################


#Get the Curl Install Script
CURL_INSTALL_SCRIPT="$INSTALL_SCRIPTS/curl-install-list.sh"

if [[ ! -f "$CURL_INSTALL_SCRIPT" ]]; then
    echo "Error: File '$CURL_INSTALL_SCRIPT' not found!" >&2
    exit 1
fi

#Get the Curl Install List
CURL_LIST="$INSTALL_LISTS/curl-list.txt"

if [[ ! -f "$CURL_LIST" ]]; then
    echo "Error: File '$CURL_LIST' not found!" >&2
    exit 1
fi

#Install Curl packages.
echo "Installing Curl Packages"
bash "$CURL_INSTALL_SCRIPT" "$CURL_LIST"


############################################################
#                       GIT PROGRAMS                       #
############################################################


#Get the Git Install Script
GIT_INSTALL_SCRIPT="$INSTALL_SCRIPTS/git-install-list.sh"

if [[ ! -f "$GIT_INSTALL_SCRIPT" ]]; then
    echo "Error: File '$GIT_INSTALL_SCRIPT' not found!" >&2
    exit 1
fi

#Get the Git Install List
GIT_LIST="$INSTALL_LISTS/git-list.txt"

if [[ ! -f "$GIT_LIST" ]]; then
    echo "Error: File '$GIT_LIST' not found!" >&2
    exit 1
fi

#Install Git packages.
echo "Installing Git Packages."
bash "$GIT_INSTALL_SCRIPT" "$GIT_LIST" "$REPOS"


############################################################
#                       CONFIG SCRIPTS                     #
############################################################


#Get the Script Runner Script
SCRIPT_SCRIPT="$INSTALL_SCRIPTS/script-config-list.sh"

if [[ ! -f "$SCRIPT_SCRIPT" ]]; then
    echo "Error: File '$SCRIPT_SCRIPT' not found!" >&2
    exit 1
fi

#Get the Git Install List
SCRIPT_LIST="$INSTALL_LISTS/script-list.txt"

if [[ ! -f "$SCRIPT_LIST" ]]; then
    echo "Error: File '$SCRIPT_LIST' not found!" >&2
    exit 1
fi

#Run Config Scripts.
echo "Running Configuration Scripts."
bash "$SCRIPT_SCRIPT" "$SCRIPT_LIST" 

