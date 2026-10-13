# Salim's Dotfiles

My macOS development environment. Terminal-first, keyboard-driven, and themed end-to-end with [Catppuccin Mocha](https://github.com/catppuccin/catppuccin).

[![macOS](https://img.shields.io/badge/macOS-Tahoe-000000?logo=apple&logoColor=white)](https://www.apple.com/macos/)
[![License](https://img.shields.io/github/license/salimmohamed/dotfiles)](LICENSE)
[![Catppuccin](https://img.shields.io/badge/theme-Catppuccin%20Mocha-b4befe?logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxNiIgaGVpZ2h0PSIxNiI+PHRleHQgeD0iMCIgeT0iMTIiIGZvbnQtc2l6ZT0iMTIiPvCfkr48L3RleHQ+PC9zdmc+)](https://github.com/catppuccin/catppuccin)

![Setup](.assets/setup.png)

> Tiling windows with AeroSpace, a Lua-powered status bar, Ghostty + cmux + tmux for terminal life, Zed for code, and offline TTS audiobook reading — all wired together with vim keybindings.

## What's Inside

| Tool | Purpose | Config |
|------|---------|--------|
| [AeroSpace](https://github.com/nikitabobko/AeroSpace) | Tiling window manager | `aerospace/` |
| [Sketchybar](https://github.com/FelixKratz/SketchyBar) | Custom status bar | `sketchybar/` |
| [Ghostty](https://ghostty.org) | Terminal emulator | `ghostty/` |
| [cmux](https://github.com/anthropics/claude-code) | Claude Code terminal (daily driver) | — |
| [tmux](https://github.com/tmux/tmux) | Terminal multiplexer | `tmux/` |
| [Zed](https://zed.dev) | Primary editor | `zed/` |
| [Neovim](https://neovim.io) | Quick terminal editing (LazyVim) | `nvim/` |
| [Zsh](https://www.zsh.org) | Shell | `zsh/` |
| [Starship](https://starship.rs) | Prompt | `starship.toml` |
| [Lue](https://github.com/superstarryeyes/lue) | Terminal eBook reader with TTS | `lue/` |
| [JankyBorders](https://github.com/FelixKratz/JankyBorders) | Window borders | `borders/` |
| [Spicetify](https://spicetify.app) | Spotify theming | `spicetify/` |
| [Brewfile](https://github.com/Homebrew/homebrew-bundle) | Package management | `Brewfile` |

## Architecture

The tools form a tightly integrated stack:

```
Zed (primary editor) / Neovim (quick terminal edits)
cmux (Claude Code terminal) ─── daily driver for AI-assisted dev
Ghostty (terminal) → auto-launches tmux → runs Zsh + Starship prompt
     ↓                      ↓
  Cmd+key          Ctrl+a prefix (which-key menu)
  passthrough              ↓
  to tmux           Lazygit / fzf popups / Lue (eBook reader)
```

**Design principles:**
- Catppuccin Mocha theme across every tool
- Vim-style `hjkl` navigation everywhere (AeroSpace, tmux, Lue, Zed)
- Modal keybindings with leader/prefix keys
- Minimal UI chrome, maximum content space
- Frosted glass transparency on the terminal

---

## AeroSpace (Window Manager)

Tiling window manager with vim-style navigation using `Alt` as the modifier key.

- **Navigation:** `Alt+h/j/k/l` to move focus between windows
- **Move windows:** `Alt+Shift+h/j/k/l` to swap window positions
- **Workspaces:** `Alt+1-4` to switch, `Alt+Shift+1-4` to move windows
- **Layouts:** `Alt+/` (tiles), `Alt+,` (accordion), `Alt+f` (floating toggle)
- **Resize:** `Alt+Shift+-/=` for quick resize, `Alt+r` enters resize mode with fine control
- **Service mode:** `Alt+Shift+;` for admin operations (reset layout, balance sizes, close others)
- **Gaps:** 10px inner, 10-15px outer
- **Floating rules:** Finder, System Settings, iPhone Mirroring, games, and other non-tileable apps
- **Auto-routing:** Apps auto-move to assigned workspaces (Ghostty→1, Browsers→2, Obsidian→3, Messaging→4, IDEs→C, Spotify→S)
- **Integration:** Sends workspace change events to Sketchybar for live workspace indicators
- **Follow-floats:** Floating apps (Finder, System Settings, etc.) follow you across workspaces

## Ghostty (Terminal)

GPU-accelerated terminal with frosted glass aesthetics.

- **Theme:** Catppuccin Mocha
- **Font:** JetBrainsMono Nerd Font, size 18
- **Window:** 70% opacity, 20px blur radius, no title bar or window decoration
- **Shell integration:** Auto-launches `tmux new-session -A -s main` (attaches to existing or creates new)
- **Cursor:** Blinking block

**Cmd+key passthrough to tmux** (Ghostty translates macOS-native shortcuts into escape sequences tmux understands):

| Shortcut | Action |
|----------|--------|
| `Cmd+1-9` | Switch tmux window 1-9 |
| `Cmd+t` | New tmux window |
| `Cmd+w` | Close tmux pane |
| `Cmd+d` | Split vertical |
| `Cmd+Shift+d` | Split horizontal |
| `Cmd+Shift+Enter` | Zoom pane |
| `Cmd+e` | Window tree |
| `Cmd+Shift+w` | Session picker |

## tmux

Terminal multiplexer with session persistence and a which-key menu for discoverability.

- **Prefix:** `Ctrl+a`
- **Theme:** Catppuccin Mocha (v2.1.3) with battery + time in status bar
- **History:** 50,000 lines
- **Mouse:** Enabled
- **Windows/panes:** Start at index 1 (not 0)
- **Window naming:** Auto-shows current directory name, with special handling for versioned tools

**Which-key menu** (`Ctrl+a Space`): Opens a categorized menu with all available keybindings organized under Copy, Windows, Panes, Buffers, Sessions, and Client submenus.

**Key bindings (with prefix):**

| Binding | Action |
|---------|--------|
| `h/j/k/l` | Navigate panes (vim-style) |
| `s` / `v` | Split vertical / horizontal |
| `Space` | Which-key menu |
| `g` | Popup lazygit (floating overlay) |
| `w` | Window/session tree |
| `W` | fzf session picker (fuzzy search) |
| `N` | New named session |
| `Ctrl+t` | Scratch terminal (persistent) |
| `z` | Switch to rehoboam control session |
| `R` | Reload config |

**Plugins (via TPM):**
- `tmux-resurrect` + `tmux-continuum` — auto-save sessions every 15 min, restore on start
- `tmux-yank` — clipboard integration
- `tmux-battery` — battery widget in status bar
- `catppuccin/tmux` — theme
- `tmux-which-key` — Space-triggered categorized menu

**Pane borders:** Shows current directory and pane title at the top of each pane.

## Neovim

Zed is my primary editor, but Neovim is kept configured for quick terminal editing when I need to jump into a file without leaving the terminal. LazyVim-based, focused on distraction-free editing.

- **Framework:** [LazyVim](https://www.lazyvim.org/) with selective customization
- **Diagnostics:** All sign column indicators hidden (clean gutter)

**Plugins:**

| Plugin | Purpose | Key binding |
|--------|---------|-------------|
| `lazygit.nvim` | Git UI in floating window | `<leader>lg` |
| `smart-splits.nvim` | Seamless vim-tmux pane navigation | `Ctrl+h/j/k/l` |
| `neo-tree.nvim` | File explorer with git status | LazyVim default |
| `blink.cmp` | Completion engine (disabled in Markdown) | Auto |
| `toggleterm.nvim` | Integrated terminal splits | `Ctrl+\`, `<leader>r` (run file) |
| `obsidian.nvim` | Obsidian vault integration | `<leader>o` prefix |

**toggleterm** supports running the current file with `<leader>r` — auto-detects Python, Node, Lua, Bash, and Zsh.

**Obsidian integration:**
- Workspace: `~/Learn/Notes/Main`
- Daily notes in `2 - Source Material/Leetcode/` with date format `%B %d %Y`
- Custom daily regimen template with time-blocked schedule (Morning/Afternoon/Evening)
- Keybindings: `<leader>ot` (today), `<leader>oy` (yesterday), `<leader>od` (daily regimen), `<leader>os` (search), `<leader>on` (new note)

## Zsh + Starship

Zsh shell with XDG-compliant config directory and Starship prompt.

**Shell architecture:**
- `home/.zshenv` → sets `ZDOTDIR=~/.config/zsh` (redirects all zsh config to XDG location)
- `zsh/.zshenv` → adds `~/.local/bin` to PATH, loads the Rust/cargo env
- `zsh/.zprofile` → initializes Homebrew (Apple Silicon or Intel), loads OrbStack integration
- `zsh/.zshrc` → sources config modules, sets aliases, adds tool paths

**Config modules:**
- `config/prompt.zsh` — Starship prompt init
- `config/zoxide.zsh` — Smart directory jumping (frecency-based `cd` replacement)
- `config/completion.zsh` — Zsh autosuggestions (Fish-like, history + completion strategy)

**Custom aliases & functions:**
- `tb` — Launch tmux-boot (interactive project session picker)
- `rh` — Switch to rehoboam control session
- `tka` — Kill all tmux sessions, clear resurrect state, close Ghostty
- `book` — Fuzzy-search Calibre library and open in Lue (sorted by recently read, hides books tagged "hidden")
- `c` — Shortcut for `claude --dangerously-skip-permissions`
- `rbars` — Restart AeroSpace and Sketchybar
- Secrets (e.g. `HF_TOKEN`) live in `zsh/config/secrets.zsh` (gitignored, created from `secrets.zsh.example`)

**Starship prompt:**
- Two-line format with green bracket styling
- Shows: directory (truncated to 3 levels), git branch + status, language versions (Python/Rust/Go/Node)
- Right side: battery status (color-coded), command duration (if >2s), time (12-hour)
- Git status symbols for conflicts, ahead/behind, diverged, modified, staged, renamed, deleted
- Green `❯` on success, red `❯` on error

## Sketchybar

Lua-based status bar with real-time system monitoring.

- **Theme:** Catppuccin Mocha with semi-transparent dark background
- **Height:** 32px, positioned at top
- **Fonts:** SF Pro (text), SF Mono (numbers), SF Symbols (icons)
- **AeroSpace integration:** Custom module queries AeroSpace via Unix domain socket for live workspace state

**Widgets:** Workspace indicators, front app name, WiFi, CPU, battery, volume, media controls, clock

## JankyBorders (Window Borders)

- **Active window:** White border (`#ffffff`)
- **Inactive window:** Muted dark gray (`#494d64`)
- **Style:** Rounded (radius 6.0), rendered above windows
- **Excluded:** Screen Studio

## Lue (eBook Reader)

![Lue](.assets/lue.png)

Terminal-based eBook reader with offline TTS, integrated with Calibre library. Planning to fork and rewrite in Rust for better performance.

- **TTS:** Kokoro (offline, 82M params) with `af_heart` voice at 1.4x default speed
- **Theme:** Catppuccin Mocha — custom highlighting with Rosewater (active sentence), Pink (current word)
- **Keybindings:** Vim-style (`lue/keys.json`) — `h/j/k/l` for sentence/paragraph navigation, `H/G/g` for jumps
- **Playback:** Space/p for play/pause, `,`/`.` to adjust speed, `s`/`w` to toggle highlights
- **Session timer:** Built-in reading timer in the bottom bar
- **Calibre integration:** `book` shell command (in `.zshrc`) that queries Calibre's SQLite database, filters hidden-tagged books, sorts by recently read, and opens a fuzzy picker via fzf

## Zed (Editor)

Primary code editor, configured at `zed/settings.json`.

## Spicetify (Spotify)

![Spotify](.assets/spotify.png)

- **Theme:** Catppuccin Mocha via the marketplace
- CSS injection enabled, custom apps (marketplace), experimental features
- Spotify's own updater is blocked so updates don't wipe the theme
- **Updating:** the `Update Spotify + Spicetify` Raycast command (`scripts/raycast-commands/spotify-update.sh`) closes Spotify, upgrades Spicetify and Spotify, then reapplies the theme in the right order

## Alcove (Dynamic Island)

[Alcove](https://github.com/TheBoredTeam/Alcove) adds a Dynamic Island-style notch area to macOS. It lives behind the MacBook notch and activates on hover or system events, showing:

- **Media controls** — album art, play/pause, skip (appears when music is playing)
- **Volume/brightness** — visual sliders that pop up on adjustment
- **Power status** — battery and charging info on cable connect/disconnect

Alcove runs as a menu bar app and requires no configuration — it works out of the box with the system notch.

## macOS Defaults

The `macos/defaults.sh` script configures system preferences:

- **Keyboard:** 2x faster key repeat, no auto-correct, no smart quotes/dashes
- **Trackpad:** Tap to click, three-finger drag
- **Finder:** Show hidden files + all extensions, path bar, list view by default, search current folder, no .DS_Store on network/USB volumes, show ~/Library
- **Dock:** Auto-hide, 33px icons, don't auto-rearrange Spaces, hide recent apps
- **Appearance:** Dark mode, native menu bar hidden (Sketchybar replaces it), no tiled-window margins
- **Screenshots:** Save to ~/Downloads, PNG format, no shadows
- **Hot corners:** Top-left → Mission Control
- **Menu bar:** Battery percentage, custom time format
- **Activity Monitor:** All processes, sort by CPU usage

---

## Keybinding Reference

### Window Management (AeroSpace — Alt modifier)

| Binding | Action |
|---------|--------|
| `Alt+h/j/k/l` | Focus window left/down/up/right |
| `Alt+Shift+h/j/k/l` | Move window left/down/up/right |
| `Alt+1-4,C,S` | Switch to workspace |
| `Alt+f` | Toggle floating |
| `Alt+/` | Tiles layout |
| `Alt+,` | Accordion layout |
| `Alt+r` | Enter resize mode |

### Terminal (Ghostty Cmd → tmux)

| Binding | Action |
|---------|--------|
| `Cmd+t` | New window |
| `Cmd+w` | Close pane |
| `Cmd+d` / `Cmd+Shift+d` | Split vertical / horizontal |
| `Cmd+1-9` | Switch window |
| `Cmd+Shift+Enter` | Zoom pane |

### tmux (Ctrl+a prefix)

| Binding | Action |
|---------|--------|
| `Space` | Which-key menu |
| `h/j/k/l` | Navigate panes |
| `g` | Popup lazygit |
| `w` / `W` | Window tree / fzf session picker |
| `Ctrl+t` | Scratch terminal |

### Neovim

| Binding | Action |
|---------|--------|
| `Ctrl+h/j/k/l` | Navigate splits (works across tmux) |
| `<leader>lg` | Lazygit |
| `<leader>r` | Run current file |
| `<leader>o...` | Obsidian commands |
| `Ctrl+\` | Toggle terminal |

---

## Custom Scripts

### tmux-boot (`scripts/bin/tmux-boot`)

Interactive project session launcher using `gum` for terminal UI.

- Reads project definitions from `~/.config/claude-hooks/projects.json` (gitignored; created from `projects.example.json`)
- Sorts projects by priority, or by zoxide frecency with `--frecency`
- Multi-select with `gum choose` (Catppuccin-styled)
- Each selected project gets its own tmux session with `claude` running
- Usage: `tmux-boot` (interactive), `--all`, `--list`, `--add`, `--remove`, `--frecency`

### nvim-clean-swaps (`scripts/bin/nvim-clean-swaps.sh`)

Cleans orphaned Neovim swap files.

### vault-auto-pull (`scripts/bin/vault-auto-pull.sh`)

Fast-forwards the Obsidian vault at `~/Learn/Notes` every 5 minutes (only on `main` with a clean tree). Runs from the LaunchAgent in `launchd/`.

Everything in `scripts/bin/` is symlinked into `~/.local/bin`, so edits here are live immediately.

---

## Installation

### Fresh Mac (one command)

```bash
curl -fsSL https://raw.githubusercontent.com/salimmohamed/dotfiles/master/install.sh | bash
```

That's it. `install.sh` will:

1. Ask for your password once (kept alive for the whole install)
2. Install the Xcode Command Line Tools (click **Install** in the dialog)
3. Install Homebrew
4. Clone this repo straight into `~/.config` (anything already there is backed up to `~/.dotfiles-backup-<timestamp>/` and app folders are left in place)
5. Run `scripts/bootstrap.sh`

To also apply the macOS defaults without being asked: `... | bash -s -- --macos`

### What the Bootstrap Does

Every step is idempotent and a failed step doesn't stop the rest (failures are listed at the end), so re-running it is also how an existing Mac gets brought up to date.

1. Trusts the Brewfile's taps (required since Homebrew 7) and runs `brew bundle`
2. Symlinks `home/.zshenv` → `~/.zshenv` and `scripts/bin/*` → `~/.local/bin/` (real files in the way are backed up)
3. Creates the gitignored local files from their examples (`claude-hooks/projects.json`, `zsh/config/secrets.zsh`)
4. Installs TPM + tmux plugins
5. Builds [SbarLua](https://github.com/FelixKratz/SbarLua) for Sketchybar
6. Installs lue (`pipx`), Claude Code (native installer) and the Spicetify CLI
7. Themes Spotify (launches it once in the background if needed, then `spicetify backup apply`)
8. Offers `gh auth login` and clones the Obsidian vault to `~/Learn/Notes`
9. Restores Neovim plugins from `lazy-lock.json`
10. Loads LaunchAgents from `launchd/` (vault auto-pull)
11. Starts the Sketchybar and Borders services
12. Opens AeroSpace, AltTab, Hidden Bar, Raycast and Alcove, plus the Accessibility settings pane
13. Optionally applies `macos/defaults.sh`
14. Prints what's left: permissions and sign-ins macOS won't let a script grant

### Options

```bash
~/.config/scripts/bootstrap.sh --dry-run     # Preview every change
~/.config/scripts/bootstrap.sh --skip-brew   # Skip brew bundle
~/.config/scripts/bootstrap.sh --macos       # Apply macOS defaults without asking
~/.config/scripts/bootstrap.sh --skip-macos  # Don't apply or ask
~/.config/scripts/link.sh                    # Just (re)create the symlinks
```

### Keeping It Up to Date

```bash
brew bundle check --file=~/.config/Brewfile --verbose   # What's missing here
brew bundle dump --file=- | diff - ~/.config/Brewfile    # What's installed but not tracked
```

### Automated Setup with Claude Code

See [SETUP.md](SETUP.md) for instructions Claude Code can follow on a fresh Mac, including verification.

---

## Brewfile Summary

**Taps:** AeroSpace, Sketchybar/Borders (FelixKratz), Bun, opencode, Supabase, Atlassian, Obsidian vault CLI

**CLI Tools:** git, neovim (HEAD), ripgrep, fd, fzf, jq, lazygit, tmux, starship, zoxide, zsh-autosuggestions, gum, gh, awscli, railway, render, supabase, tailscale, syncthing, ffmpeg, pandoc, mas

**Languages:** Python 3.14 / 3.12, Node, Bun, Rust, Lua, GCC

**Applications:** Ghostty, cmux, Zed, Cursor, VS Code, Claude, OrbStack, AeroSpace, AltTab, Raycast, Hidden Bar, Alcove, 1Password, Obsidian, TickTick, Arc, Chrome, Slack, Spotify, and more

**Fonts:** JetBrainsMono Nerd Font, SF Mono, SF Pro, sketchybar-app-font

**Also:** Mac App Store apps (via `mas`), global npm packages, cargo packages, and 39 VS Code extensions

---

## Structure

```
~/.config/                         # This repository
├── aerospace/                     # Tiling window manager
│   ├── aerospace.toml             # Main config + keybindings
│   ├── follow-floats.sh           # Floating window helper
│   ├── workspace-change.sh        # Deferred workspace-change hook
│   └── watch-reload.sh            # Auto-reload on config change
├── borders/
│   └── bordersrc                  # Window border styling
├── gh/
│   └── config.yml                 # GitHub CLI preferences
├── ghostty/
│   └── config                     # Terminal theme, font, keybindings
├── ccstatusline/
│   └── settings.json              # Claude Code status line
├── claude-hooks/
│   └── projects.example.json      # tmux-boot projects template
├── git/
│   ├── config                     # Global git identity
│   └── ignore                     # Global gitignore
├── home/                          # Files symlinked to ~/
│   └── .zshenv                    # → ~/.zshenv (sets ZDOTDIR)
├── launchd/                       # LaunchAgents (vault auto-pull)
├── lue/                           # Terminal eBook reader
│   └── keys.json                  # Vim-style keyboard shortcuts
├── macos/
│   └── defaults.sh                # macOS system preferences script
├── nvim/                          # Neovim (LazyVim)
│   ├── init.lua                   # Entry point
│   ├── lua/config/                # Options, keymaps, autocmds
│   └── lua/plugins/               # Plugin configs
├── scripts/
│   ├── bootstrap.sh               # Main setup (idempotent)
│   ├── link.sh                    # Symlink manager (with backups)
│   ├── raycast-commands/          # Raycast script commands
│   └── bin/                       # → ~/.local/bin (tmux-boot, etc.)
├── sketchybar/                    # Status bar (Lua-based)
│   ├── init.lua                   # Entry point
│   ├── bar.lua                    # Bar appearance
│   ├── colors.lua                 # Catppuccin Mocha palette
│   ├── settings.lua               # Font and spacing
│   ├── aerospace.lua              # Workspace integration
│   └── items/                     # Individual widgets
├── spicetify/                     # Spotify theming
│   ├── config-xpui.ini            # Spicetify settings
│   ├── CustomApps/                # Marketplace app
│   └── Themes/                    # Catppuccin theme files
├── tmux/
│   ├── tmux.conf                  # Main config + plugins
│   └── which-key-config.yaml      # Which-key menu structure
├── zed/                           # Zed editor
│   └── settings.json              # Editor preferences
├── zsh/
│   ├── .zshrc                     # Interactive shell config (includes book command)
│   ├── .zshenv                    # Environment variables
│   ├── .zprofile                  # Login shell (Homebrew init)
│   └── config/                    # Modules (prompt, zoxide, completion)
├── catppuccin-mocha.md            # Full color palette reference
├── starship.toml                  # Prompt configuration
├── Brewfile                       # Homebrew packages
├── install.sh                     # Fresh Mac one-liner installer
├── SETUP.md                       # Claude Code automated setup guide
└── LICENSE                        # MIT
```

---

## Inspiration & Credits

- [FelixKratz/dotfiles](https://github.com/FelixKratz/dotfiles) — Sketchybar + AeroSpace reference
- [Tnixc/dots](https://github.com/Tnixc/dots)
- [tnixc/nix-config](https://github.com/tnixc/nix-config)
- [khaneliman/dotfiles](https://github.com/khaneliman/dotfiles)
- [ris-tlp/dotfiles](https://github.com/ris-tlp/dotfiles)
- [Mathias Bynens' dotfiles](https://github.com/mathiasbynens/dotfiles) — macOS defaults
- [Holman's dotfiles](https://github.com/holman/dotfiles)
- [Dotfiles GitHub Guide](https://dotfiles.github.io/)

## License

MIT — feel free to use anything here as inspiration for your own setup.
