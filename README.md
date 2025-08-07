# NPE-DEV dotfiles

Collection of my dotfiles for zshr, kube, git etc

## Requirements

- macOS
- Homebrew (the install script will install Homebrew)
- Zsh (the install script will install Zsh via Homebrew)

### Automatically

Run the install script to set up your environment:

```shell
git clone git@github.com:npe-dev/dotfiles.git ~/dotfiles
~/dotfiles/setup.sh
```

### Working with stow
#### Activate symlink
stow -t ~ zsh
# Delete exist
stow -D -t ~ zsh


### AWS cli not working well with stow for now manually symlink the aws directory
#### TODO: include that actions in 
ln -s $HOME/Projects/dotfiles/aws .aws