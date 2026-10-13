# Autonomous Setup Guide for Claude Code

Step-by-step instructions for Claude Code to replicate this environment on a fresh Mac.

**To use:** open Claude Code on the new Mac and paste:
> Set up my dotfiles from https://github.com/salimmohamed/dotfiles — follow SETUP.md exactly.

---

## How the repo is laid out

The repo **is** `~/.config`. Nearly every tool (AeroSpace, Ghostty, tmux, Zed, Neovim, Sketchybar, Starship, gh, git) reads its config from `~/.config` natively, so there's almost nothing to symlink. The only links are:

- `~/.zshenv` → `~/.config/home/.zshenv` (sets `ZDOTDIR=~/.config/zsh`)
- `~/.local/bin/*` → `~/.config/scripts/bin/*`

## 1. Run the installer

The installer needs a real terminal for the sudo password and the Xcode CLT dialog. Ask the user to run this in their own terminal (Terminal.app or Ghostty), not through a tool call:

```bash
curl -fsSL https://raw.githubusercontent.com/salimmohamed/dotfiles/master/install.sh | bash
```

It installs the Xcode Command Line Tools and Homebrew, clones the repo into `~/.config` (backing up anything already there), and runs `scripts/bootstrap.sh`. The Homebrew bundle step takes a while (large casks, Xcode from the App Store).

If the repo is already at `~/.config`, run the bootstrap directly instead:

```bash
~/.config/scripts/bootstrap.sh
```

Re-running either is safe: every step is idempotent and failed steps are listed at the end.

## 2. Check the result

```bash
ls -la ~/.zshenv                                        # → ~/.config/home/.zshenv
ls -la ~/.local/bin                                     # tmux-boot etc. → ~/.config/scripts/bin/
git -C ~/.config status -sb                             # clean, tracking origin/master
brew bundle check --file=~/.config/Brewfile --verbose   # lists anything still missing
zsh -l -i -c 'echo $ZDOTDIR; command -v starship zoxide claude tmux-boot'
```

Common failures and fixes:

- **Mac App Store apps failed:** expected until the user signs in to the App Store; then re-run `brew bundle --file=~/.config/Brewfile`
- **Spotify theme failed:** open Spotify once, quit it, then re-run the bootstrap (or `spicetify backup apply`)
- **"Refusing to load formula ... from untrusted tap":** run `brew trust --tap <tap>` (the bootstrap does this for every `tap` in the Brewfile)
- **A cask failed because the app already exists:** `brew install --cask --adopt <name>`
- **Sketchybar blank:** check SbarLua exists at `~/.local/share/sketchybar_lua/sketchybar.so`, then `brew services restart sketchybar`
- **tmux plugins missing:** `~/.config/tmux/plugins/tpm/bin/install_plugins`

## 3. Manual steps (need the user)

The bootstrap already themes Spotify, offers the GitHub sign-in, clones the Obsidian vault, and opens the apps that need permissions. What's left needs clicks or sign-ins macOS won't let a script do:

1. **Accessibility:** allow AeroSpace, AltTab, Hidden Bar and Raycast in System Settings → Privacy & Security → Accessibility (the bootstrap opens this pane)
2. **Raycast:** set ⌘Space as its hotkey, and add `~/.config/scripts/raycast-commands` as a script directory (Settings → Extensions → + → Add Script Directory)
3. **Sign-ins:** 1Password, the App Store (then `brew bundle --file=~/.config/Brewfile` to install the App Store apps), and `claude`
4. **If GitHub sign-in was skipped:** `gh auth login && gh auth setup-git`, then re-run `~/.config/scripts/bootstrap.sh --skip-brew` to clone the vault and load the auto-pull agent
5. **Secrets (optional):** fill in `~/.config/zsh/config/secrets.zsh` (e.g. `HF_TOKEN` for lue's Kokoro voice)
6. **tmux-boot projects:** add projects with `tmux-boot --add`
7. **macOS defaults:** if skipped, run `~/.config/macos/defaults.sh`, then log out and back in

## Key commands after setup

| Command | What it does |
|---------|-------------|
| `tb` | tmux-boot: pick projects and start a Claude Code tmux session for each |
| `c` | `claude --dangerously-skip-permissions` |
| `rbars` | Restart AeroSpace + Sketchybar |
| `tka` | Kill all tmux sessions + Ghostty |
| `book` | Pick a Calibre book and read it in lue |
| `Ctrl+a Space` | tmux which-key menu |
| `Ctrl+a g` | Floating lazygit |
