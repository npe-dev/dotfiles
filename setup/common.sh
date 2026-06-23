#!/bin/bash
#
# Shared helpers for setup scripts
# OS detection + cross-platform package installation + print helpers
#
# Author: Nikolay Petrov
# License: MIT
#
# Source this at the top of any setup script:
#   source "$(dirname "$0")/common.sh"

# ───────────────────────────────────────────────
# COLORS
# ───────────────────────────────────────────────
RED=$(tput setaf 1 2>/dev/null || echo "")
GREEN=$(tput setaf 2 2>/dev/null || echo "")
YELLOW=$(tput setaf 3 2>/dev/null || echo "")
BLUE=$(tput setaf 4 2>/dev/null || echo "")
BOLD=$(tput bold 2>/dev/null || echo "")
RESET=$(tput sgr0 2>/dev/null || echo "")

# ───────────────────────────────────────────────
# PRINT HELPERS
# ───────────────────────────────────────────────
info()    { echo "${BLUE}${BOLD}[INFO]${RESET} $*"; }
success() { echo "${GREEN}${BOLD}[ OK ]${RESET} $*"; }
warning() { echo "${YELLOW}${BOLD}[WARN]${RESET} $*"; }
error()   { echo "${RED}${BOLD}[ERR ]${RESET} $*" >&2; }

# ───────────────────────────────────────────────
# OS DETECTION
# Sets:
#   OS_NAME  -> "macos" | "linux"
#   DISTRO   -> "arch" | "debian" | "<id>" | ""   (linux only)
#   PKG_MGR  -> "brew" | "pacman" | ""
# ───────────────────────────────────────────────
detect_os() {
    case "$(uname -s)" in
        Darwin)
            OS_NAME="macos"
            PKG_MGR="brew"
            ;;
        Linux)
            OS_NAME="linux"
            if [[ -r /etc/os-release ]]; then
                DISTRO="$(. /etc/os-release && echo "${ID:-}")"
            fi
            if command -v pacman &>/dev/null; then
                PKG_MGR="pacman"
            elif command -v apt-get &>/dev/null; then
                PKG_MGR="apt"
            fi
            ;;
        *)
            OS_NAME="unknown"
            ;;
    esac
    export OS_NAME DISTRO PKG_MGR
}
detect_os

is_macos() { [[ "$OS_NAME" == "macos" ]]; }
is_linux() { [[ "$OS_NAME" == "linux" ]]; }
is_arch()  { [[ "$DISTRO" == "arch" ]]; }

# ───────────────────────────────────────────────
# AUR HELPER (Arch only)
# Sets AUR_HELPER to yay/paru if available.
# ───────────────────────────────────────────────
detect_aur_helper() {
    if command -v yay &>/dev/null; then
        AUR_HELPER="yay"
    elif command -v paru &>/dev/null; then
        AUR_HELPER="paru"
    else
        AUR_HELPER=""
    fi
    export AUR_HELPER
}
detect_aur_helper

# ───────────────────────────────────────────────
# PACKAGE INSTALL WRAPPERS
# ───────────────────────────────────────────────
brew_install() { brew install "$@"; }

pac_install() {
    sudo pacman -S --needed --noconfirm "$@"
}

# Install from the AUR (Arch). Falls back to a warning if no helper.
aur_install() {
    if [[ -n "$AUR_HELPER" ]]; then
        "$AUR_HELPER" -S --needed --noconfirm "$@"
    else
        warning "No AUR helper (yay/paru) found. Skipping AUR package(s): $*"
        warning "Install one first, e.g.: sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si"
        return 1
    fi
}

# ───────────────────────────────────────────────
# SAFE STOW
# Stow packages into $HOME, automatically backing up any pre-existing
# *real* files/dirs that would otherwise cause a conflict (e.g. the
# default ~/.zshrc the Oh My Zsh installer writes).
#   safe_stow zsh aws starship nvim
# ───────────────────────────────────────────────
safe_stow() {
    if ! command -v stow &>/dev/null; then
        error "Stow not found! Install it first (it's in the core packages)."
        return 1
    fi

    cd "$HOME/dotfiles" || return 1

    # Remove any existing symlinks we own so re-runs are clean
    stow -D -t "$HOME" "$@" 2>/dev/null || true

    # Back up real files/dirs that would conflict (not symlinks)
    local ts target
    ts="$(date +%Y%m%d-%H%M%S)"
    while IFS= read -r target; do
        [[ -z "$target" ]] && continue
        if [[ -e "$HOME/$target" && ! -L "$HOME/$target" ]]; then
            warning "Backing up existing ~/$target -> ~/${target}.bak-$ts"
            mv "$HOME/$target" "$HOME/${target}.bak-$ts"
        fi
    done < <(stow -n -t "$HOME" "$@" 2>&1 \
                | grep "existing target" \
                | sed -E 's/.*over existing target (.+) since.*/\1/')

    if stow -t "$HOME" "$@"; then
        success "Dotfiles symlinked successfully!"
    else
        error "Failed to create symlinks with Stow"
        error "Run manually: cd ~/dotfiles && stow -t ~ $*"
        return 1
    fi
}

# pkg_install <command-to-check> <brew-name> [pacman-name] [--aur]
#   Installs only if <command-to-check> is missing.
#   pacman-name defaults to brew-name when omitted.
#   Pass --aur as the last arg to install from the AUR on Arch.
pkg_install() {
    local check="$1" brew_name="$2" linux_name="${3:-$2}" from_aur=""
    [[ "${!#}" == "--aur" ]] && from_aur="yes"

    if command -v "$check" &>/dev/null; then
        success "$check already installed"
        return 0
    fi

    info "Installing $check..."
    case "$PKG_MGR" in
        brew)
            brew_install "$brew_name"
            ;;
        pacman)
            if [[ -n "$from_aur" ]]; then
                aur_install "$linux_name"
            else
                pac_install "$linux_name"
            fi
            ;;
        *)
            error "No supported package manager found for installing $check"
            return 1
            ;;
    esac
}
