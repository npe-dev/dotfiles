#!/bin/bash
#
# Setup a new machine with all dotfiles (cross-platform: macOS + Arch Linux)
#
# Author: Nikolay Petrov
# License: MIT
# https://github.com/npe-dev/dotfiles

source "$HOME/dotfiles/setup/common.sh"

info "Detected OS: ${OS_NAME}${DISTRO:+ ($DISTRO)} — package manager: ${PKG_MGR:-none}"
if [[ "$OS_NAME" != "macos" && "$DISTRO" != "arch" ]]; then
    warning "This setup is tested on macOS and Arch Linux only."
    warning "On other systems some package installs may be skipped."
fi
echo

# Ask for the password upfront
warning "Activate sudo access"
if sudo -v; then
    success "Sudo activated!"
else
    error "Failed to gain sudo access!"
    exit 1
fi

# Install core packages (also syncs the package DB on Arch)
info "📦 Setting up core packages..."
source "$HOME/dotfiles/setup/packages.sh"
echo

# Setup Zsh (installs zsh itself if missing, then makes it the default shell)
info "Setting up Zsh..."
source "$HOME/dotfiles/zsh/setup/zsh.sh"
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
# safe_stow backs up any pre-existing real files (e.g. the default ~/.zshrc
# the Oh My Zsh installer writes) so the symlinks never conflict.
info "🔗 Creating symlinks with Stow..."
safe_stow zsh aws starship nvim || exit 1
echo

# Create config file if it doesn't exist
if [ ! -f "$HOME/dotfiles/config" ]; then
    info "Creating config file from template..."
    cp "$HOME/dotfiles/config.example" "$HOME/dotfiles/config"
    warning "Please edit ~/dotfiles/config to set your environment variables"
fi

echo
success "All done! Open a new terminal for the changes to take effect."