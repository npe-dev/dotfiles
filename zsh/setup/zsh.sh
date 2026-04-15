#!/usr/bin/env bash
set -e

current_shell=$(basename "$SHELL")
zsh_path=$(command -v zsh)

if [ "$SHELL" = "$zsh_path" ]; then
  success "Zsh is already your default shell 👏"
else
  warning "Changing shell to $zsh_path..."
  if chsh -s "$zsh_path"; then
    success "Default shell changed to zsh ✅"
    info "Restart your terminal or open a new tab to start using it."
  else
    error "Failed to change shell! You may need to run: sudo chsh -s $zsh_path \$USER"
    exit 1
  fi
fi

# ───────────────────────────────────────────────
# Install zsh plugins if not already installed
# ───────────────────────────────────────────────
plugin_dir="$HOME/dotfiles/zsh/.zsh-plugins"
fzf_tab_dir="$plugin_dir/fzf-tab"

info "Installing fzf-tab plugin..."
mkdir -p "$plugin_dir"

if [ ! -d "$fzf_tab_dir" ]; then
    git clone --depth=1 --quiet https://github.com/Aloxaf/fzf-tab "$fzf_tab_dir" 2>/dev/null
    success "fzf-tab plugin installed!"
else
    success "fzf-tab already installed"
fi
success "Zsh setup complete!"
