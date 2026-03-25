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

# Install Oh My Zsh
info "🚀 Setting up Oh My Zsh..."
source "$HOME/dotfiles/setup/oh-my-zsh.sh"
echo

# Install Starship
info "✨ Setting up Starship..."
source "$HOME/dotfiles/setup/starship.sh"
echo

# Install NVM
info "📦 Setting up NVM..."
source "$HOME/dotfiles/setup/nvm.sh"
echo

# Optional: Install work-specific tools
read -p "Do you want to install optional tools (aws-vault, lazygit, sops, etc.)? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    info "🔧 Setting up optional tools..."
    source "$HOME/dotfiles/setup/optional-tools.sh"
    echo
else
    info "Skipping optional tools. You can run setup/optional-tools.sh later."
    echo
fi

# Symlink dotfiles with Stow
info "🔗 Creating symlinks with Stow..."
cd "$HOME/dotfiles"
if command -v stow &>/dev/null; then
    # Remove existing symlinks to avoid conflicts
    stow -D -t ~ zsh aws starship 2>/dev/null || true
    # Create new symlinks
    if stow -t ~ zsh aws starship > /dev/null 2>&1; then
        success "Dotfiles symlinked successfully!"
    else
        error "Failed to create symlinks with Stow"
        error "Run manually: cd ~/dotfiles && stow -t ~ zsh aws starship"
        exit 1
    fi
else
    error "Stow not found! Please install stow first."
    exit 1
fi
echo

# Create config file if it doesn't exist
if [ ! -f "$HOME/dotfiles/config" ]; then
    info "Creating config file from template..."
    cp "$HOME/dotfiles/config.example" "$HOME/dotfiles/config"
    warning "Please edit ~/dotfiles/config to set your environment variables"
fi

echo
success "All done! Open a new terminal for the changes to take effect."