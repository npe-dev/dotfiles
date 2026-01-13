#!/bin/bash
#
# Homebrew setup script
# Install Homebrew and essential packages
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

# ───────────────────────────────────────────────
# INSTALL HOMEBREW
# ───────────────────────────────────────────────
if ! command -v brew &>/dev/null; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    success "Homebrew installed!"
else
    success "Homebrew already installed"
fi

# ───────────────────────────────────────────────
# UPDATE HOMEBREW
# ───────────────────────────────────────────────
info "Updating Homebrew..."
brew update

# ───────────────────────────────────────────────
# INSTALL PACKAGES
# ───────────────────────────────────────────────
info "Installing Homebrew packages..."

# Core utilities
brew install \
    yazi \
    ffmpeg \
    sevenzip \
    jq \
    poppler \
    fd \
    ripgrep \
    fzf \
    zoxide \
    resvg \
    imagemagick \
    font-symbols-only-nerd-font \
    stow \
    git \
    curl \
    wget

success "All packages installed!"

# ───────────────────────────────────────────────
# CLEANUP
# ───────────────────────────────────────────────
info "Cleaning up..."
brew cleanup

success "Homebrew setup complete!"
