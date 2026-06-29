# Aliases
alias ohmy="${EDITOR:-vim} ~/.zshrc"

# Prefer colorls when installed, otherwise fall back to a sensible ls
if command -v colorls &>/dev/null; then
  alias lls="colorls -la"
  alias ll="colorls"
else
  alias lls="ls -la"
  alias ll="ls -l"
fi
alias hints_display='vim $HOME/Dropbox/$CURRENT_CLIENT/hints.md'

# Current client specifics
alias gto="cd $CLIENT_ROOT/$CURRENT_APP"
alias gtd="cd $CLIENT_ROOT/docker-$CURRENT_APP"
alias gte="cd $CLIENT_ROOT/evaluation"

# Kubernetes aliases
alias kk="k9s"
alias kgy="kubectl get -o yaml"

# # Clusters alias
alias testkube="kubectl config use-context test"
alias infrakube="kubectl config use-context infra"
alias prodkube="kubectl config use-context prod"
alias uskube="kubectl config use-context prod-us"
alias cakube="kubectl config use-context prod-ca"
alias chkube="kubectl config use-context prod-ch"
alias drpkube="kubectl config use-context prod-drp"

# Docker compose shortcuts
alias dcd="docker compose down"
alias dcu="docker compose up -d"

# Lazygit
alias lg="lazygit"

# Sops helper
alias spf="sops-helper -f"


# Nvim
alias nv="nvim"
