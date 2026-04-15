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
for file in "$ZSHRC_DIR"/zsh-includes/*.zsh(.N); do
  [[ "$file" != "$ZSHRC_DIR/zsh-includes/.zshrc" ]] && source "$file"
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
plugins=(git sudo kubectl zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh
# Cache eval outputs for faster startup
_cache_eval() {
  local cache_file="$HOME/.zsh-cache/$1"
  if [[ ! -f "$cache_file" || ! -s "$cache_file" ]]; then
    mkdir -p "$HOME/.zsh-cache"
    eval "$2" > "$cache_file"
  fi
  source "$cache_file"
}

_cache_eval "starship.zsh" "starship init zsh"

zstyle ':omz:update' mode auto
# zstyle ':fzf-tab:*' complete-with-space false

# Restore normal Tab behavior
#bindkey '^I' expand-or-complete
# Trigger fzf-tab only on Shift+Tab
#bindkey '^[Z' fzf-tab-complete


if command -v zoxide &>/dev/null; then
  _cache_eval "zoxide.zsh" "zoxide init zsh"
fi

_cache_eval "fzf.zsh" "fzf --zsh"

# EXPORTS
export KUBECONFIG=~/.kube/config
export LANG="en_US.UTF-8" # (updated)
export PHP_CS_FIXER_IGNORE_ENV=1
export GEM_HOME="$HOME/.gem"
export PATH="/opt/homebrew/opt/mysql/bin:/opt/homebrew/opt/mysql-client/bin:/opt/homebrew/opt/ruby/bin:$GEM_HOME/bin:/usr/local/bin:/usr/local/sbin:~/bin:${KREW_ROOT:-$HOME/.krew}/bin:$PATH:/Users/npe/.gem/bin:/Users/npe/Library/Python/3.9/bin"

# Lazy-load NVM (speeds up shell startup)
export NVM_DIR="$HOME/.nvm"
lazy_load_nvm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}
nvm() { lazy_load_nvm && nvm "$@"; }
node() { lazy_load_nvm && node "$@"; }
npm() { lazy_load_nvm && npm "$@"; }
npx() { lazy_load_nvm && npx "$@"; }

export REPO_LOCATION="/Users/npe/Optimy"

# peon-ping quick controls
alias peon="bash /Users/npe/.claude/hooks/peon-ping/peon.sh"
[ -f /Users/npe/.claude/hooks/peon-ping/completions.bash ] && source /Users/npe/.claude/hooks/peon-ping/completions.bash

# Compile zcompdump in background for faster startup
{
  zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    zcompile "$zcompdump"
  fi
} &!
export PATH="$HOME/.local/bin:$PATH"
