#!/bin/bash
#
# Starship setup script (cross-platform)
# Install Starship prompt via Homebrew (macOS) or pacman (Arch).
#
# Author: Nikolay Petrov
# License: MIT

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

# ───────────────────────────────────────────────
# INSTALL STARSHIP
# ───────────────────────────────────────────────
if command -v starship &>/dev/null; then
    success "Starship already installed"
elif is_macos || is_arch; then
    pkg_install starship starship
else
    # Fallback: official install script (works on any Linux/macOS)
    info "Installing Starship via official installer..."
    curl -fsSL https://starship.rs/install.sh | sh -s -- --yes
fi

success "Starship setup complete!"
