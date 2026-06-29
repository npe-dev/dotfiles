#!/bin/bash
#
# Optional tools setup script (cross-platform)
# Install work-specific and optional development tools.
# These are not required for basic functionality.
#
# Author: Nikolay Petrov
# License: MIT

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

warning "This script installs optional work-specific tools."
warning "Skip this if you don't need AWS, PHP, or other optional tools."
echo

# ───────────────────────────────────────────────
# AWS TOOLS
# ───────────────────────────────────────────────
# aws-vault lives in the AUR on Arch, Homebrew on macOS.
if is_arch; then
    pkg_install aws-vault aws-vault aws-vault --aur
else
    pkg_install aws-vault aws-vault
fi

# AWS CLI: brew name "awscli", Arch package "aws-cli-v2".
pkg_install aws awscli aws-cli-v2

# ───────────────────────────────────────────────
# GIT TOOLS
# ───────────────────────────────────────────────
pkg_install lazygit lazygit

# ───────────────────────────────────────────────
# FILE LISTING TOOLS
# ───────────────────────────────────────────────
if ! command -v colorls &>/dev/null; then
    info "Installing colorls..."
    # colorls is a Ruby gem on every platform
    if command -v gem &>/dev/null; then
        gem install colorls > /dev/null 2>&1 && success "colorls installed!" \
            || warning "colorls install failed (check Ruby/gem setup)."
    else
        warning "Ruby/gem not found. Skipping colorls installation."
        if is_arch; then
            info "Install Ruby first: sudo pacman -S ruby"
        else
            info "Install Ruby first: brew install ruby"
        fi
    fi
else
    success "colorls already installed"
fi

# ───────────────────────────────────────────────
# PHP TOOLS (Optional for PHP developers)
# ───────────────────────────────────────────────
if command -v php &>/dev/null; then
    info "PHP detected. PHP tools available via Composer."
    info "Install phpstan: composer global require phpstan/phpstan"
else
    info "PHP not detected. Skipping PHP-specific tools."
fi

# ───────────────────────────────────────────────
# SECRETS MANAGEMENT
# ───────────────────────────────────────────────
pkg_install sops sops

success "Optional tools setup complete!"
