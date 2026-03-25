#!/bin/bash
#
# NVM setup script
# Install Node Version Manager (NVM)
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
# INSTALL NVM
# ───────────────────────────────────────────────
if [ ! -d "$HOME/.nvm" ]; then
    info "Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh 2>/dev/null | bash > /dev/null 2>&1

    # Load NVM for this session
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    success "NVM installed!"

    # Install latest LTS version of Node.js
    if command -v nvm &>/dev/null; then
        info "Installing Node.js LTS..."
        nvm install --lts > /dev/null 2>&1
        nvm use --lts > /dev/null 2>&1
        success "Node.js LTS installed!"
    fi
else
    success "NVM already installed"
fi

success "NVM setup complete!"
