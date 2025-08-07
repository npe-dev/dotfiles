#!/bin/bash
#
# Setup new macOS machine with all dotfiles
#
# Author: Nikolay Petrov
# License: MIT
# https://github.com/npe-dev/dotfiles

# Ask for the password upfront
warning "Activate sudo access"
sudo echo "Sudo activated!"
echo

# Setup Zsh
title "Setting up Zsh..."
$HOME/dotfiles/setup/zsh.sh
echo

# Install Homebrew and packages/apps
title "🫖 Setting up Homebrew..."
$HOME/dotfiles/setup/brew.sh
echo


### Another way to setup dotfiles
# TODO Loop over each directory and execute install.sh script
#
# Run all dotfiles installers.
# set -e

# Get the absolute path of the main script
#SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

#echo $SCRIPT_DIR
# Change to the main directory
# cd "${SCRIPT_DIR}"

# Find all subdirectories and execute install.sh in each
# find . -mindepth 1 -type d -exec sh -c 'cd "{}" && [ -e install.sh ] && sh install.sh' \;

echo
echo "🦏 ${green}All done! Open a new terminal for the changes to take effect.${reset}"