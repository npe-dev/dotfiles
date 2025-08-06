#!/bin/bash

bold() {
  echo "${bold}==> $1${reset}"
  echo
}

# Check if Zsh is already the default shell
if [ "$SHELL" == "/opt/homebrew/bin/zsh" ]; then
  echo "Nothing to update. You're already using Zsh as your default shell 👏"
  exit 0
fi

zsh_path=$(which zsh)

bold "Changing shell to $zsh_path..."
chsh -s "$zsh_path"
echo "Your shell has been changed to zsh, please restart your terminal or tab"
echo