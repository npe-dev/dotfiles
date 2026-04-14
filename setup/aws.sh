#!/bin/bash
#
# AWS config setup script
# Generates ~/.aws/config from template using variables in dotfiles/config
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
# RESOLVE PATHS
# ───────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
TEMPLATE="$DOTFILES_DIR/aws/.aws/config.template"
CONFIG="$DOTFILES_DIR/config"
TARGET="$HOME/.aws/config"

# ───────────────────────────────────────────────
# SOURCE CONFIG
# ───────────────────────────────────────────────
if [[ ! -f "$CONFIG" ]]; then
    error "Config file not found: $CONFIG"
    error "Copy config.example to config and fill in your values."
    exit 1
fi

source "$CONFIG"

# ───────────────────────────────────────────────
# VALIDATE
# ───────────────────────────────────────────────
if [[ ! -f "$TEMPLATE" ]]; then
    error "Template not found: $TEMPLATE"
    exit 1
fi

if [[ -z "$AWS_ACCOUNT_INFRA" || -z "$AWS_ACCOUNT_PROD" || -z "$AWS_ACCOUNT_DRP" ]]; then
    error "Missing AWS account variables in config."
    error "Ensure AWS_ACCOUNT_INFRA, AWS_ACCOUNT_PROD, and AWS_ACCOUNT_DRP are set."
    exit 1
fi

# ───────────────────────────────────────────────
# GENERATE
# ───────────────────────────────────────────────
info "Generating AWS config..."
mkdir -p "$HOME/.aws"
envsubst < "$TEMPLATE" > "$TARGET"
success "AWS config generated at $TARGET"

# ───────────────────────────────────────────────
# AWS-VAULT SETUP
# ───────────────────────────────────────────────
if ! command -v aws-vault &>/dev/null; then
    warning "aws-vault not installed. Run setup/optional-tools.sh first."
    exit 0
fi

if [[ -z "$AWS_VAULT_PROFILES" ]]; then
    warning "No AWS_VAULT_PROFILES defined in config. Skipping vault setup."
    exit 0
fi

for profile in $AWS_VAULT_PROFILES; do
    if aws-vault list 2>/dev/null | grep -q "$profile.*$profile"; then
        success "aws-vault credentials already exist for $profile"
    else
        info "Adding aws-vault credentials for $profile..."
        info "You will be prompted for your AWS Access Key ID and Secret Access Key."
        aws-vault add "$profile"
    fi
done
