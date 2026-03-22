#!/bin/bash
#
# Starship setup script
# Install Starship prompt
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
# INSTALL STARSHIP
# ───────────────────────────────────────────────
if ! command -v starship &>/dev/null; then
    info "Installing Starship..."
    brew install starship
    success "Starship installed!"
else
    success "Starship already installed"
fi

success "Starship setup complete!"
