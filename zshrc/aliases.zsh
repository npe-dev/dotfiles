# Aliases
alias ohmy="code ~/.zshrc"
alias ll="colorls -la"
#alias ls="colorls"

alias hints_display='vim $HOME/Dropbox/$CURRENT_CLIENT/hints.md'

# Current client specifics
alias gto="cd $CLIENT_ROOT/$CURRENT_APP"
alias gtd="cd $CLIENT_ROOT/docker-$CURRENT_APP"
alias gte="cd $CLIENT_ROOT/evaluation"

# Kubernetes aliases
alias kk="k9s"

# # Clusters alias
alias testkube="kubectl config use-context test"
alias infrakube="kubectl config use-context infra"
alias prodkube="kubectl config use-context prod"
alias uskube="kubectl config use-context prod-us"
alias cakube="kubectl config use-context prod-ca"
alias chkube="kubectl config use-context prod-ch"

# Docker compose shortcuts
alias dcd="docker compose down"
alias dcu="docker compose up -d"

# Lazygit
alias lg="lazygit"

# Sops helper
alias spf="sops-helper -f"