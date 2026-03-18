# NPE-DEV Dotfiles

Personal dotfiles configuration for macOS development environment. This repository contains configurations for Zsh, Starship prompt, Kubernetes tools, AWS CLI, and various development utilities.

## Features

- **Zsh Configuration**: Custom `.zshrc` with Oh My Zsh, plugins, and modular configuration system
- **Starship Prompt**: Beautiful cross-shell prompt with Kubernetes and AWS context display
- **Kubernetes Integration**: Aliases, functions, and context switching for multi-cluster management
- **AWS Configuration**: AWS CLI settings and profile management
- **Automated Setup**: One-command installation script for new macOS machines
- **Custom Functions**: Base64 encoding, stack management, and productivity shortcuts
- **Homebrew Packages**: Curated list of essential development tools

## Requirements

- **macOS** (tested on macOS 10.15+)
- **Homebrew** (automatically installed by setup script)
- **Zsh** (automatically installed via Homebrew)
- **Git** (for cloning and managing dotfiles)

## Quick Start

### Automatic Installation

Clone this repository and run the setup script:

```bash
git clone git@github.com:npe-dev/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh
```

The setup script will:
1. Request sudo access for system-level changes
2. Set up Zsh as your default shell
3. Install Homebrew and essential packages
4. Configure Oh My Zsh and plugins
5. Set up symlinks using GNU Stow

### Manual Installation with Stow

If you prefer manual control, use GNU Stow to create symlinks:

```bash
# Link specific configurations
stow -t ~ zsh aws starship

# Unlink if needed
stow -D -t ~ zsh
```

## Repository Structure

```
.
├── aws/              # AWS CLI configuration
│   └── .aws/
│       └── config
├── setup/            # Installation scripts
│   └── brew.sh      # Homebrew and package installation
├── starship/         # Starship prompt configuration
│   └── starship.toml
├── zsh/              # Zsh configuration
│   ├── .zsh-includes/
│   │   ├── aliases.zsh      # Custom aliases
│   │   └── functions.zsh    # Custom functions
│   ├── .zshrc              # Main Zsh configuration
│   ├── config.example      # Example environment variables
│   └── setup/
│       └── zsh.sh          # Zsh setup script
├── config.example    # Global configuration example
├── setup.sh         # Main setup script
└── README.md
```

## Configuration

### Environment Variables

Copy `config.example` to `config` and customize:

```bash
cp config.example config
```

Edit the `config` file to set your project-specific variables:

```bash
export CURRENT_CLIENT="YourClient"
export CURRENT_APP="your-app"
export CLIENT_ROOT="$HOME/$CURRENT_CLIENT"
```

### Zsh Configuration

The Zsh setup includes:

- **Oh My Zsh**: Popular Zsh framework with plugins
- **Plugins**: git, sudo, kubectl, zsh-autosuggestions
- **Starship Prompt**: Fast, customizable prompt with context awareness
- **fzf**: Fuzzy finder integration
- **zoxide**: Smarter cd command
- **Custom aliases and functions**: Loaded from `.zsh-includes/`

### Starship Prompt

The Starship configuration (`starship/starship.toml`) includes:

- **Kubernetes context**: Shows current cluster and namespace (when AWS_VAULT is active)
- **AWS profile**: Displays active AWS profile
- **Command duration**: Shows execution time for long-running commands
- **Git integration**: Branch, status indicators, and remote tracking
- **Language versions**: PHP, Node.js, Python, Go, Rust, Java

### Installed Tools

The `setup/brew.sh` script installs the following packages:

**File Management & Navigation:**
- `yazi` - Terminal file manager
- `zoxide` - Smarter cd command
- `fzf` - Fuzzy finder

**Development Tools:**
- `git` - Version control
- `stow` - Symlink manager for dotfiles
- `jq` - JSON processor

**Search & Text Processing:**
- `ripgrep` - Fast grep alternative
- `fd` - Fast find alternative

**Media & Documents:**
- `ffmpeg` - Video/audio processing
- `imagemagick` - Image manipulation
- `resvg` - SVG rendering
- `poppler` - PDF utilities

**Utilities:**
- `curl`, `wget` - File download tools
- `sevenzip` - Archive utility
- `font-symbols-only-nerd-font` - Icon font for terminal

## Custom Aliases

Key aliases defined in `zsh/.zsh-includes/aliases.zsh`:

```bash
# Configuration
alias ohmy="code ~/.zshrc"

# Kubernetes shortcuts
alias kk="k9s"
alias testkube="kubectl config use-context test"
alias infrakube="kubectl config use-context infra"
alias prodkube="kubectl config use-context prod"

# Project navigation
alias gto="cd $CLIENT_ROOT/$CURRENT_APP"
alias gtd="cd $CLIENT_ROOT/docker-$CURRENT_APP"
```

## Custom Functions

Functions defined in `zsh/.zsh-includes/functions.zsh`:

- **`ss()`**: Stack management wrapper
- **`bf()`**: Base64 encode (interactive)
- **`obf()`**: Base64 encode (with clipboard copy)
- And more utility functions for development workflows

## Kubernetes Integration

The dotfiles include extensive Kubernetes tooling:

- **k9s**: Terminal UI for Kubernetes
- **kubectl plugins**: Via krew package manager
- **Context switching aliases**: Quick cluster switching
- **Starship integration**: Shows current context and namespace

## Maintenance

### Updating Oh My Zsh

Oh My Zsh auto-updates are enabled. Manual update:

```bash
omz update
```

### Updating Homebrew packages

```bash
brew update && brew upgrade && brew cleanup
```

### Adding new Zsh configurations

Add new `.zsh` files to `zsh/.zsh-includes/` - they're automatically loaded by `.zshrc`.

### Git Status

The repository uses Stow for symlink management. Current tracked files:

- `zsh/.zshrc` (modified)
- All configuration files under version control

## Theme

Recommended iTerm2 theme: [Material Design](https://github.com/MartinSeeler/iterm2-material-design)

## Troubleshooting

### Zsh not loading configurations

Ensure symlinks are created correctly:

```bash
ls -la ~/.zshrc
# Should point to ~/dotfiles/zsh/.zshrc
```

### Homebrew installation fails

Check Xcode Command Line Tools:

```bash
xcode-select --install
```

### Starship not showing

Verify Starship is installed and initialized:

```bash
which starship
# Should output: /opt/homebrew/bin/starship (or similar)
```

Check that `eval "$(starship init zsh)"` is present in `.zshrc`.

## Contributing

This is a personal dotfiles repository. Feel free to fork and adapt for your own use.

## License

MIT License - See [LICENSE](LICENSE) file for details.

## Author

**Nikolay Petrov**
- GitHub: [@npe-dev](https://github.com/npe-dev)

## Acknowledgments

- [Oh My Zsh](https://ohmyz.sh/)
- [Starship](https://starship.rs/)
- [GNU Stow](https://www.gnu.org/software/stow/)
- [Homebrew](https://brew.sh/)
