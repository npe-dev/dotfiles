#!/bin/bash
#
# NVM setup script (cross-platform: works on macOS and Linux)
# Install Node Version Manager (NVM)
#
# Author: Nikolay Petrov
# License: MIT

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

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
