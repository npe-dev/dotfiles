
ZSHRC_DIR="$(dirname -- "$(realpath -- "${(%):-%N}")")"
DOTFILES_DIR="$(realpath -- "$ZSHRC_DIR/..")"

[[ -f "$DOTFILES_DIR/.config" ]] && source "$DOTFILES_DIR/.config"

# Source all .zsh files in the same directory, excluding .zshrc
for file in "$ZSHRC_DIR"/.zsh-includes/*.zsh(.N); do
  [[ "$file" != "$ZSHRC_DIR/.zsh-includes/.zshrc" ]] && source "$file"
done

# p10k
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Plugins
plugins=(git sudo kubectl fzf-tab zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

if command -v zoxide &>/dev/null; then
  eval "$(zoxide init --cmd cd zsh)"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
export PATH=/usr/local/bin:/usr/local/sbin:~/bin:$PATH

# Kubectl context
autoload -U colors; colors
source $HOME/.oh-my-zsh/custom/plugins/zsh-kubectl-prompt/kubectl.zsh
RPROMPT='%{$fg[blue]%}($ZSH_KUBECTL_PROMPT)%{$reset_color%}'

export LANG="en_US.UTF-8" # (updated)
export PHP_CS_FIXER_IGNORE_ENV=1

export PATH="/opt/homebrew/opt/mysql/bin:$PATH"
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/npe/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions
