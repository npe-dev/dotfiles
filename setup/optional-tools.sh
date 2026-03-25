#!/bin/bash
#
# Optional tools setup script
# Install work-specific and optional development tools
# These are not required for basic functionality
#
# Author: Nikolay Petrov
# License: MIT

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

warning "This script installs optional work-specific tools."
warning "Skip this if you don't need AWS, PHP, or other optional tools."
echo

# ───────────────────────────────────────────────
# AWS TOOLS
# ───────────────────────────────────────────────
if ! command -v aws-vault &>/dev/null; then
    info "Installing aws-vault..."
    brew install aws-vault
    success "aws-vault installed!"
else
    success "aws-vault already installed"
fi

if ! command -v aws &>/dev/null; then
    info "Installing AWS CLI..."
    brew install awscli
    success "AWS CLI installed!"
else
    success "AWS CLI already installed"
fi

# ───────────────────────────────────────────────
# GIT TOOLS
# ───────────────────────────────────────────────
if ! command -v lazygit &>/dev/null; then
    info "Installing lazygit..."
    brew install lazygit
    success "lazygit installed!"
else
    success "lazygit already installed"
fi

# ───────────────────────────────────────────────
# FILE LISTING TOOLS
# ───────────────────────────────────────────────
if ! command -v colorls &>/dev/null; then
    info "Installing colorls..."
    # colorls requires Ruby
    if command -v gem &>/dev/null; then
        gem install colorls > /dev/null 2>&1
        success "colorls installed!"
    else
        warning "Ruby/gem not found. Skipping colorls installation."
        info "Install Ruby first: brew install ruby"
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
if ! command -v sops &>/dev/null; then
    info "Installing sops (secrets encryption)..."
    brew install sops
    success "sops installed!"
else
    success "sops already installed"
fi

success "Optional tools setup complete!"
