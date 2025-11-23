# Dotfiles

My personal macOS configuration files for a productive development environment.

## What's Inside

- **aerospace**: Tiling window manager configuration for efficient workspace management
- **sketchybar**: Custom status bar with system monitoring and workspace indicators
- **neovim**: Text editor configuration with plugins and custom keybindings
- **wezterm**: Terminal emulator with GPU acceleration and custom styling
- **zsh**: Shell configuration with aliases, functions, and prompt customization
- **raycast**: Custom scripts and extensions for the Raycast launcher
- **Brewfile**: All Homebrew packages, casks, and VS Code extensions

## Requirements

- macOS Sonoma or later (tested on macOS 15.1)
- Xcode Command Line Tools
- Git
- [Homebrew](https://brew.sh/) (will be installed automatically if not present)

## Installation

### Quick Start

```bash
# Clone the repository
git clone https://github.com/salimmohamed/.config.git ~/dotfiles
cd ~/dotfiles

# Run the bootstrap script
./scripts/bootstrap.sh
```

### What Gets Installed

The bootstrap script will:

1. **Install Homebrew** (if not already installed)
2. **Install all packages** from the Brewfile:
   - CLI tools (neovim, git, ripgrep, etc.)
   - Applications (WezTerm, Cursor, Aerospace, etc.)
   - Fonts (JetBrains Mono Nerd Font, SF Mono, SF Pro)
   - VS Code extensions
3. **Backup existing dotfiles** to `~/.dotfiles-backup-[timestamp]`
4. **Create symlinks**:
   - `~/.config` → `~/dotfiles`
   - `~/.zshrc` → `~/dotfiles/home/.zshrc`
   - `~/.zshenv` → `~/dotfiles/home/.zshenv`
5. **Apply macOS system defaults** (optional, with confirmation)

### Installation Options

```bash
# Dry run - see what would be done without making changes
./scripts/bootstrap.sh --dry-run

# Skip Homebrew installation
./scripts/bootstrap.sh --skip-brew

# Skip macOS defaults
./scripts/bootstrap.sh --skip-macos
```

### Manual Installation

If you prefer to install step-by-step:

```bash
# 1. Install Homebrew packages
brew bundle --file=Brewfile

# 2. Backup existing config
./scripts/backup.sh

# 3. Create symlinks
./scripts/symlink.sh

# 4. Apply macOS defaults (optional)
./macos/defaults.sh
```

## Structure

```
~/dotfiles/                    # This repository
├── .config/                   # XDG config directory
│   ├── aerospace/             # Window manager
│   ├── sketchybar/           # Status bar
│   ├── nvim/                 # Neovim editor
│   ├── wezterm/              # Terminal emulator
│   ├── zsh/                  # Shell configuration
│   └── raycast/              # Launcher extensions
├── home/                      # Files for $HOME
│   ├── .zshrc                # Zsh main config
│   ├── .zshenv               # Zsh environment
│   └── .bashrc               # Bash config
├── macos/
│   └── defaults.sh           # System preferences
├── scripts/
│   ├── bootstrap.sh          # Main installation script
│   ├── symlink.sh            # Symlink management
│   └── backup.sh             # Backup utility
├── Brewfile                   # Package manager
├── README.md                  # This file
├── .gitignore                # Git ignore patterns
└── LICENSE                    # MIT License
```

## Customization

### Local Configuration

Create local override files that won't be tracked by git:

```bash
# Shell overrides
~/.zshrc.local        # Additional zsh configuration
~/.zshenv.local       # Environment variables

# Git overrides
~/.gitconfig.local    # Personal git config (name, email, etc.)
```

### Modifying macOS Defaults

Edit `macos/defaults.sh` to customize system preferences:

```bash
# Edit the defaults script
nvim macos/defaults.sh

# Apply changes
./macos/defaults.sh
```

### Adding New Packages

Update the Brewfile and reinstall:

```bash
# Edit Brewfile
nvim Brewfile

# Install new packages
brew bundle --file=Brewfile
```

## Key Features

### Aerospace

- Tiling window management with vim-style keybindings
- Three workspace setup
- Automatic window organization
- Integration with Sketchybar

### Sketchybar

- Custom status bar with dark blur aesthetic
- Real-time system monitoring (WiFi, battery, CPU, memory)
- Workspace indicators synced with Aerospace
- Application icon display with Nerd Font icons
- Interactive popups for system controls

### Neovim

- Modern Lua configuration
- LSP support for multiple languages
- File explorer, fuzzy finder, and git integration
- Custom keybindings and snippets

### WezTerm

- GPU-accelerated terminal
- Custom color scheme and styling
- Ligature support with Nerd Fonts
- Tab and split management

### Zsh

- Starship prompt for fast, informative shell prompt
- Aliases and functions for common tasks
- Zoxide for smart directory jumping
- Syntax highlighting and autosuggestions

## Updating

To update your dotfiles and installed packages:

```bash
cd ~/dotfiles

# Pull latest changes
git pull

# Update Homebrew packages
brew bundle --file=Brewfile

# Restart affected applications
killall Dock Finder SystemUIServer
```

## Backup & Restore

### Backup

Backups are automatically created before installation in:
```
~/.dotfiles-backup-[timestamp]/
```

### Restore

To restore from a backup:

```bash
# Find your backup
ls ~/.dotfiles-backup-*

# Restore all files
cp -R ~/.dotfiles-backup-[timestamp]/* ~/
```

### Uninstalling

To remove the dotfiles:

```bash
# 1. Restore from backup (see above)

# 2. Remove symlinks
rm ~/.config
unlink ~/.zshrc
unlink ~/.zshenv
# ... remove other symlinks

# 3. Optionally remove the dotfiles directory
rm -rf ~/dotfiles
```

## Troubleshooting

### Symlinks Not Working

If symlinks aren't created properly:

```bash
# Check what's linked
ls -la ~ | grep " -> "

# Manually run symlink script
./scripts/symlink.sh
```

### Homebrew Issues

```bash
# Update Homebrew
brew update

# Check for issues
brew doctor

# Reinstall packages
brew bundle --file=Brewfile --force
```

### macOS Defaults Not Applied

Some changes require a full logout or restart:

```bash
# Restart Dock and Finder
killall Dock Finder SystemUIServer

# If still not working, logout or restart
```

## Screenshots

> TODO: Add screenshots of your setup

## Inspiration & Credits

This dotfiles setup was inspired by:

- [Dotfiles GitHub Guide](https://dotfiles.github.io/)
- [Mathias Bynens' dotfiles](https://github.com/mathiasbynens/dotfiles)
- [Holman's dotfiles](https://github.com/holman/dotfiles)
- [AeroSpace Window Manager](https://github.com/nikitabobko/AeroSpace)
- [FelixKratz's dotfiles](https://github.com/FelixKratz/dotfiles)

## License

MIT License - feel free to use and modify as you wish.

## Contributing

Found a bug or have a suggestion? Feel free to open an issue or submit a pull request!
