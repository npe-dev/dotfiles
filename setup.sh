#!/bin/bash
#
# Setup new macOS machine with all dotfiles
#
# Author: Nikolay Petrov
# License: MIT
# https://github.com/npe-dev/dotfiles


# ───────────────────────────────────────────────
# COLORS
# ───────────────────────────────────────────────
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
BOLD=$(tput bold)
RESET=$(tput sgr0)

# ───────────────────────────────────────────────
# PRINT HELPERS
# ───────────────────────────────────────────────
info()    { echo "${BLUE}${BOLD}[INFO]${RESET} $*"; }
success() { echo "${GREEN}${BOLD}[ OK ]${RESET} $*"; }
warning() { echo "${YELLOW}${BOLD}[WARN]${RESET} $*"; }
error()   { echo "${RED}${BOLD}[ERR ]${RESET} $*" >&2; }


# Ask for the password upfront
warning "Activate sudo access"
if sudo -v; then
    success "Sudo activated!"
else
    error "Failed to gain sudo access!"
    exit 1
fi

# Setup Zsh
info "Setting up Zsh..."
source "$HOME/dotfiles/zsh/setup/zsh.sh"
echo

# Install Homebrew and packages/apps
info "🫖 Setting up Homebrew..."
source "$HOME/dotfiles/setup/brew.sh"
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
success "All done! Open a new terminal for the changes to take effect."