# ============================================================
#   CUSTOM ZSHRC
#   Maintained by: NPE
#   Location: ~/dotfiles
#   Purpose: Personal configuration and customizations
# ============================================================

ZSHRC_DIR="$(dirname -- "$(realpath -- "${(%):-%N}")")"
DOTFILES_DIR="$(realpath -- "$ZSHRC_DIR/..")"

# Custom config to load global variables
[[ -f "$DOTFILES_DIR/config" ]] && source "$DOTFILES_DIR/config"
# Source all .zsh files in the same directory, excluding .zshrc
for file in "$ZSHRC_DIR"/.zsh-includes/*.zsh(.N); do
  [[ "$file" != "$ZSHRC_DIR/.zsh-includes/.zshrc" ]] && source "$file"
done

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="false" # I think it was false before

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Plugins
plugins=(git sudo kubectl fzf-tab zsh-autosuggestions) #

source $ZSH/oh-my-zsh.sh
eval "$(starship init zsh)"

zstyle ':omz:update' mode auto
# zstyle ':fzf-tab:*' complete-with-space false

# Restore normal Tab behavior
bindkey '^I' expand-or-complete
# Trigger fzf-tab only on Shift+Tab
bindkey '^[Z' fzf-tab-complete


if command -v zoxide &>/dev/null; then
#   eval "$(zoxide init --cmd cd zsh)"
  eval "$(zoxide init zsh)"
fi

# EXPORTS
export KUBECONFIG=~/.kube/config
export LANG="en_US.UTF-8" # (updated)
export PHP_CS_FIXER_IGNORE_ENV=1
export PATH="/opt/homebrew/opt/mysql/bin:$PATH"
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
export PATH=/usr/local/bin:/usr/local/sbin:~/bin:$PATH
export PATH="/usr/local/bin:$PATH"
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export GEM_HOME="$HOME/.gem"
export PATH="$GEM_HOME/bin:$PATH"
export PATH="$PATH:/Users/npe/.gem/bin"
export PATH="$PATH:/Users/npe/Library/Python/3.9/bin"
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
