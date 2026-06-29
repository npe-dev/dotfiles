#!/bin/bash
#
# Oh My Zsh setup script (cross-platform: works on macOS and Linux)
# Install Oh My Zsh and essential plugins
#
# Author: Nikolay Petrov
# License: MIT

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

# ───────────────────────────────────────────────
# INSTALL OH MY ZSH
# ───────────────────────────────────────────────
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    info "Installing Oh My Zsh..."
    # --keep-zshrc: never replace an existing ~/.zshrc (e.g. our stow symlink).
    # On a truly fresh machine OMZ still writes a default ~/.zshrc here; the
    # later safe_stow step backs that up automatically before linking ours.
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc > /dev/null 2>&1
    success "Oh My Zsh installed!"
else
    success "Oh My Zsh already installed"
fi

# ───────────────────────────────────────────────
# INSTALL ZSH-AUTOSUGGESTIONS PLUGIN
# ───────────────────────────────────────────────
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
AUTOSUGGESTIONS_DIR="$ZSH_CUSTOM/plugins/zsh-autosuggestions"

if [ ! -d "$AUTOSUGGESTIONS_DIR" ]; then
    info "Installing zsh-autosuggestions plugin..."
    git clone --quiet https://github.com/zsh-users/zsh-autosuggestions "$AUTOSUGGESTIONS_DIR" > /dev/null 2>&1
    success "zsh-autosuggestions installed!"
else
    success "zsh-autosuggestions already installed"
fi

success "Oh My Zsh setup complete!"
