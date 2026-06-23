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
export EDITOR="nvim"
export VISUAL="nvim"
export PHP_CS_FIXER_IGNORE_ENV=1
export GEM_HOME="$HOME/.gem"

# Cross-platform PATH additions
export PATH="$GEM_HOME/bin:/usr/local/bin:/usr/local/sbin:$HOME/bin:${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# macOS / Homebrew-specific PATH additions
if [[ "$OSTYPE" == darwin* ]]; then
  export PATH="/opt/homebrew/opt/mysql/bin:/opt/homebrew/opt/mysql-client/bin:/opt/homebrew/opt/ruby/bin:$PATH:$HOME/Library/Python/3.9/bin"
fi

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

export REPO_LOCATION="$HOME/Optimy"

# peon-ping quick controls
alias peon="bash $HOME/.claude/hooks/peon-ping/peon.sh"
[ -f "$HOME/.claude/hooks/peon-ping/completions.bash" ] && source "$HOME/.claude/hooks/peon-ping/completions.bash"

# Compile zcompdump in background for faster startup
{
  zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    zcompile "$zcompdump"
  fi
} &!
export PATH="$HOME/.local/bin:$PATH"

# bun completions
[ -s "$HOME/.oh-my-zsh/completions/_bun" ] && source "$HOME/.oh-my-zsh/completions/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
