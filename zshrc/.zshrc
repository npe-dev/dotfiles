
ZSHRC_DIR="$(dirname -- "$(realpath -- "${(%):-%N}")")"
DOTFILES_DIR="$(realpath -- "$ZSHRC_DIR/..")"

[[ -f "$DOTFILES_DIR/.config" ]] && source "$DOTFILES_DIR/.config"

# Source all .zsh files in the same directory, excluding .zshrc
for file in "$ZSHRC_DIR"/*.zsh(.N); do
  [[ "$file" != "$ZSHRC_DIR/.zshrc" ]] && source "$file"
done

# p10k
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Plugins
plugins=(git zsh-autosuggestions sudo kubectl)

# fast-syntax-highlighting
# zsh-syntax-highlighting
# zsh-autocomplete
# kube-aliases
source $ZSH/oh-my-zsh.sh

# export MANPATH="/usr/local/man:$MANPATH"

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Zoxide
eval "$(zoxide init --cmd cd zsh)"


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export NVM_DIR="$HOME/.nvm"
. "/opt/homebrew/opt/nvm/nvm.sh"

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"
[ -s "/usr/local/opt/nvm/etc/bash_completion" ] && \. "/usr/local/opt/nvm/etc/bash_completion"

export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"

export PATH=/usr/local/bin:/usr/local/sbin:~/bin:$PATH

# Kubectl context
autoload -U colors; colors
source $HOME/.oh-my-zsh/custom/plugins/zsh-kubectl-prompt/kubectl.zsh
RPROMPT='%{$fg[blue]%}($ZSH_KUBECTL_PROMPT)%{$reset_color%}'

export LANG="en_US.UTF-8" # (updated)
export PHP_CS_FIXER_IGNORE_ENV=1

eval "$(fzf --zsh)"
export PATH="/opt/homebrew/opt/mysql/bin:$PATH"
alias lzd='lazydocker'
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/npe/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions
