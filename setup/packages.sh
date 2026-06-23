#!/bin/bash
#
# Core package setup script (cross-platform)
# Installs Homebrew + packages on macOS, or pacman/AUR packages on Arch Linux.
#
# Author: Nikolay Petrov
# License: MIT

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

# ───────────────────────────────────────────────
# ENSURE PACKAGE MANAGER
# ───────────────────────────────────────────────
if is_macos; then
    if ! command -v brew &>/dev/null; then
        info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add Homebrew to PATH for this session and future shells
        if [[ -x /opt/homebrew/bin/brew ]]; then
            BREW_PREFIX=/opt/homebrew          # Apple Silicon
        else
            BREW_PREFIX=/usr/local             # Intel
        fi
        echo "eval \"\$($BREW_PREFIX/bin/brew shellenv)\"" >> ~/.zprofile
        eval "$($BREW_PREFIX/bin/brew shellenv)"
        success "Homebrew installed!"
    else
        success "Homebrew already installed"
    fi

    info "Updating Homebrew..."
    brew update > /dev/null 2>&1

elif is_arch; then
    info "Updating pacman databases..."
    sudo pacman -Sy --noconfirm > /dev/null 2>&1
    if [[ -z "$AUR_HELPER" ]]; then
        warning "No AUR helper (yay/paru) detected — AUR packages will be skipped."
    fi
else
    error "Unsupported OS/distro for automated package install (OS=$OS_NAME DISTRO=$DISTRO)."
    error "Install the core packages manually, then re-run the remaining setup."
    return 1 2>/dev/null || exit 1
fi

# ───────────────────────────────────────────────
# INSTALL CORE PACKAGES
# pkg_install <check-cmd> <brew-name> [linux-name] [--aur]
# ───────────────────────────────────────────────
info "Installing core packages..."

pkg_install yazi      yazi
pkg_install ffmpeg    ffmpeg
pkg_install 7z        sevenzip   7zip
pkg_install jq        jq
pkg_install pdftoppm  poppler    poppler
pkg_install fd        fd
pkg_install rg        ripgrep
pkg_install fzf       fzf
pkg_install zoxide    zoxide
pkg_install nvim      neovim
pkg_install convert   imagemagick
pkg_install stow      stow
pkg_install git       git
pkg_install curl      curl
pkg_install wget      wget

# resvg: in Homebrew core on macOS, in the AUR on Arch
if is_macos; then
    pkg_install resvg resvg
else
    pkg_install resvg resvg resvg --aur
fi

# ───────────────────────────────────────────────
# NERD FONT (icons for terminal / yazi / starship)
# ───────────────────────────────────────────────
info "Installing nerd font symbols..."
if is_macos; then
    brew install font-symbols-only-nerd-font || warning "Could not install nerd font cask"
elif is_arch; then
    pac_install ttf-nerd-fonts-symbols || warning "Could not install ttf-nerd-fonts-symbols"
fi

success "Core packages installed!"

# ───────────────────────────────────────────────
# CLEANUP
# ───────────────────────────────────────────────
if is_macos; then
    info "Cleaning up..."
    brew cleanup > /dev/null 2>&1
fi

success "Package setup complete!"
