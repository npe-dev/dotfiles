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

echo
echo "🦏 ${green}All done! Open a new terminal for the changes to take effect.${reset}"