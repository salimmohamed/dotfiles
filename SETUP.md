# Autonomous Setup Guide for Claude Code

This file contains step-by-step instructions for Claude Code to fully replicate this development environment on a fresh Mac.

**To use:** Open Claude Code on the new Mac and paste:
> Clone and set up my dotfiles from https://github.com/salimmohamed/.config.git — follow the instructions in SETUP.md exactly.

---

## Prerequisites

The target machine must be running macOS (Apple Silicon or Intel).

## Step-by-Step Instructions

### 1. Install Xcode Command Line Tools

```bash
xcode-select --install
```

Wait for installation to complete. If already installed, this will error — that's fine.

### 2. Install Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

For Apple Silicon, add Homebrew to PATH:

```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
```

### 3. Clone the Repository

```bash
git clone https://github.com/salimmohamed/dotfiles.git ~/dotfiles
```

### 4. Run the Bootstrap Script

```bash
cd ~/dotfiles
chmod +x scripts/bootstrap.sh scripts/symlink.sh scripts/backup.sh
./scripts/bootstrap.sh
```

This will:
- Install all Homebrew packages from the Brewfile
- Backup any existing dotfiles
- Create symlinks (`~/.config` → `~/dotfiles`, `~/.zshrc`, `~/.zshenv`)
- Install user scripts to `~/.local/bin/`
- Install TPM and tmux plugins
- Optionally apply macOS defaults

### 5. Post-Install: Verify Symlinks

Confirm these symlinks exist:

```bash
ls -la ~/.config    # Should point to ~/dotfiles
ls -la ~/.zshrc     # Should point to ~/dotfiles/home/.zshrc
ls -la ~/.zshenv    # Should point to ~/dotfiles/home/.zshenv
```

### 6. Post-Install: Spicetify (Spotify Customization)

Only if Spotify is installed:

```bash
brew install spicetify-cli
spicetify backup apply
```

The config at `spicetify/config-xpui.ini` will be picked up automatically.

### 7. Post-Install: Start Services

```bash
brew services start felixkratz/formulae/sketchybar
brew services start felixkratz/formulae/borders
```

### 8. Post-Install: Open Applications

Launch these apps and grant permissions when prompted:
- **Aerospace** — needs Accessibility permission
- **AltTab** — needs Accessibility permission
- **Raycast** — replace Spotlight (System Settings → Keyboard → Shortcuts)
- **HiddenBar** — needs Accessibility permission

### 9. Post-Install: Shell Setup

Restart the terminal (or open Ghostty). The shell should load with:
- Starship prompt
- Zoxide (smart cd)
- Zsh autosuggestions

If Ghostty auto-launches tmux, verify tmux loads with Catppuccin theme.

### 10. Post-Install: Neovim

Open Neovim — LazyVim will auto-install plugins on first launch:

```bash
nvim
```

Wait for all plugins to install, then quit and reopen.

### 11. Post-Install: Create projects.json (for tmux-boot)

Create the project launcher config:

```bash
mkdir -p ~/.config/claude-hooks
cat > ~/.config/claude-hooks/projects.json << 'EOF'
[
  {"name": "config", "path": "~/.config", "priority": 1}
]
EOF
```

Add more projects as needed. The `tmux-boot` command uses this to launch Claude Code sessions.

### 12. Optional: macOS System Defaults

If not applied during bootstrap:

```bash
cd ~/dotfiles
./macos/defaults.sh
```

---

## Key Commands After Setup

| Command | What it does |
|---------|-------------|
| `tb` | Launch tmux-boot (interactive project session picker) |
| `rh` | Launch rehoboam |
| `tka` | Kill all tmux sessions + Ghostty |
| `Ctrl+a Space` | Tmux which-key menu |
| `Ctrl+a w` | Tmux session/window chooser |
| `Ctrl+a g` | Floating lazygit popup |

## Troubleshooting

- **Homebrew not found after install**: Run `eval "$(/opt/homebrew/bin/brew shellenv)"`
- **Tmux plugins not loading**: Run `~/.config/tmux/plugins/tpm/bin/install_plugins`
- **Starship not showing**: Ensure `brew install starship` completed and restart shell
- **Sketchybar not running**: Run `brew services start felixkratz/formulae/sketchybar`
