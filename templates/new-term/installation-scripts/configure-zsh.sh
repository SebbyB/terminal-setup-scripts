#!/bin/bash
# -------------------------------------------------------------------------------
# Script Name:  configure-zsh.sh
# Description:  This will configure a zsh terminal with my zsh config. It will
#   copy any existing .zshrc file to ~/.zshrc-backup/(date-time-formatted-name).
#   It will not store the old file if true is passed as a parameter. 
#   False by default
#
# 	Git should be configured with correct authorization for repos that are
# 	listed as private. 
# 	If you have not set this up via something such as ssh, 
# 	it will not install your repo if it is private. 
# Author:       Sebastian Barney
# Created on:   12-12-24
# Updated on:   12-12-24
# Version:      1.0
# Usage:        ./configure-zsh.sh [CLEANUP (true | false)]
#
#       bash "$THIS_SHELL_SCRIPT" "(true | false)"
# -------------------------------------------------------------------------------

# Define variables
REPO_URL="git@github.com:SebbyB/.zshrc.git"
CONFIG_PATH="$HOME/.zshrc"
BACKUP_DIR="$HOME/.zshrc-backup"
CLEANUP=${1:-false} # Default to false, pass 'true' as the first argument to enable cleanup

#Get the directory of the script
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
LIST_DIR="$(dirname "$SCRIPT_DIR")/files"

bash "$Script_DIR/curl-oh-my-zsh.sh"

# Backup existing .zshrc
if [ -f "$CONFIG_PATH" ]; then
  echo "Backing up existing .zshrc to $BACKUP_DIR"
  mkdir -p "$BACKUP_DIR"
  mv "$CONFIG_PATH" "$BACKUP_DIR/.zshrc_$(date +%Y%m%d%H%M%S)"
fi

# Clone the repository
echo "Cloning repository..."
git clone "$REPO_URL" "$BACKUP_DIR/repo-temp"

# Move .zshrc from repo to the target path
if [ -f "$BACKUP_DIR/repo-temp/.zshrc" ]; then
  echo "Deploying .zshrc to $CONFIG_PATH"
  mv "$BACKUP_DIR/repo-temp/.zshrc" "$CONFIG_PATH"
else
  echo "Error: .zshrc file not found in repository"
  exit 1
fi


#Find the plugins directory / ensure it is there.
PLUGINS="$HOME/.oh-my-zsh/custom/plugins"
mkdir -p $PLUGINS

#Get the Git Install Script
GIT_INSTALL_SCRIPT="$HOME/repositories/terminal-setup-scripts/git-install-list.sh"

if [[ ! -f "$GIT_INSTALL_SCRIPT" ]]; then
    echo "Error: File '$GIT_INSTALL_SCRIPT' not found!" >&2
    exit 1
fi

#Get the Plugin Install List
GIT_LIST="$LIST_DIR/oh-my-zsh-plugins.txt"

if [[ ! -f "$GIT_LIST" ]]; then
    echo "Error: File '$GIT_LIST' not found!" >&2
    exit 1
fi

#Install the plugins
if [ -z "$GIT_LIST" ]; then
    echo "$GIT_LIST is empty. Skipping execution."
else
    echo "Installing Git Packages."
    bash "$GIT_INSTALL_SCRIPT" "$GIT_LIST" "$PLUGINS"
fi


#Find the plugins directory / ensure it is there.
PLUGINS="$HOME/.oh-my-zsh/custom/themes"
mkdir -p $PLUGINS


#Get the Plugin Install List
GIT_LIST="$LIST_DIR/oh-my-zsh-themes.txt"

if [[ ! -f "$GIT_LIST" ]]; then
    echo "Error: File '$GIT_LIST' not found!" >&2
    exit 1
fi

#Install the Themes
if [ -z "$GIT_LIST" ]; then
    echo "$GIT_LIST is empty. Skipping execution."
else
    echo "Installing Git Packages."
    bash "$GIT_INSTALL_SCRIPT" "$GIT_LIST" "$PLUGINS"
fi

bash "$Script_DIR/configure-p10k.sh"


# Cleanup 
if [ "$CLEANUP" = true ]; then
  echo "Cleaning up temporary files..."
  rm -rf "$BACKUP_DIR/repo-temp"
else
  echo "Cleanup skipped. Temporary files remain in $BACKUP_DIR/repo-temp"
fi

echo ".zshrc setup complete."

# Source the updated .zshrc file
if [ -f "$CONFIG_PATH" ]; then
  echo "Sourcing $CONFIG_PATH"
  zsh -c "source $CONFIG_PATH"
else
  echo "Error: $CONFIG_PATH does not exist."
fi
