# Homebrew Bundle File
# Install everything with:   brew bundle --file=~/.config/Brewfile
# Check what's missing with: brew bundle check --file=~/.config/Brewfile --verbose
# Refresh from this machine:  brew bundle dump --file=- | diff - ~/.config/Brewfile

# ========================================
# Taps
# ========================================
tap "anomalyco/tap"                # opencode
tap "atlassian/acli"               # Atlassian CLI
tap "felixkratz/formulae"          # Sketchybar + Borders
tap "nikitabobko/tap"              # AeroSpace
tap "oven-sh/bun"                  # Bun
tap "supabase/tap"                 # Supabase CLI
tap "yakitrak/yakitrak"            # Obsidian vault CLI

# ========================================
# CLI - Core Utilities
# ========================================
brew "git"                         # Version control
brew "git-filter-repo"             # Rewrite git history
brew "make"                        # GNU make
brew "ripgrep"                     # Fast grep
brew "fd"                          # Fast find
brew "jq"                          # JSON processor
brew "fzf"                         # Fuzzy finder
brew "fswatch"                     # File change monitor
brew "duti"                        # Default app associations
brew "blueutil"                    # Bluetooth from the CLI
brew "mole"                        # Mac cleanup

# ========================================
# CLI - Shell & Terminal
# ========================================
brew "tmux"                        # Terminal multiplexer
brew "starship"                    # Prompt
brew "zoxide"                      # Smarter cd
brew "zsh-autosuggestions"         # Fish-like suggestions
brew "gum"                         # TUI components (tmux-boot)
brew "lazygit"                     # Git TUI
brew "neofetch"                    # System info
brew "fish"                        # Alternate shell

# ========================================
# CLI - Development
# ========================================
brew "neovim", args: ["HEAD"]      # Editor
brew "lua"                         # Neovim + Sketchybar scripting
brew "node"                        # JavaScript runtime
brew "oven-sh/bun/bun"             # JavaScript runtime
brew "python@3.14"                 # Python
brew "python-tk@3.14"              # Tkinter for Python 3.14
brew "python@3.12"                 # Python (older projects)
brew "pipx"                        # Isolated Python CLIs (lue)
brew "rust"                        # Rust toolchain
brew "gcc"                         # GNU compilers
brew "libomp"                      # OpenMP runtime
brew "vite"                        # Frontend build tool
brew "biome"                       # JS/TS linter + formatter
brew "actionlint"                  # GitHub Actions linter
brew "anomalyco/tap/opencode"      # AI coding agent (TUI)
brew "mysql"                       # Database
brew "mysql-client"                # MySQL client

# ========================================
# CLI - Cloud & Services
# ========================================
brew "gh"                          # GitHub CLI
brew "awscli"                      # AWS CLI
brew "railway"                     # Railway CLI
brew "render"                      # Render CLI
brew "supabase/tap/supabase"       # Supabase CLI
brew "atlassian/acli/acli"         # Atlassian CLI
brew "gogcli"                      # Google Suite CLI
brew "yakitrak/yakitrak/notesmd-cli"  # Obsidian vault CLI
brew "tailscale"                   # Mesh VPN
brew "syncthing", restart_service: :changed  # File sync

# ========================================
# CLI - Media & Documents
# ========================================
brew "ffmpeg"                      # Audio/video
brew "imagemagick"                 # Images
brew "pandoc"                      # Document conversion
brew "poppler"                     # PDF tools
brew "espeak"                      # TTS (lue fallback voice)
brew "nowplaying-cli"              # Now-playing info (Sketchybar)
brew "switchaudio-osx"             # Audio device switcher (Sketchybar)

# ========================================
# CLI - Apple
# ========================================
brew "mas"                         # Mac App Store CLI
brew "ipatool"                     # iOS App Store packages

# ========================================
# Desktop - Window Management & Bar
# ========================================
cask "aerospace"                   # Tiling window manager
brew "felixkratz/formulae/sketchybar"  # Status bar
brew "felixkratz/formulae/borders"     # Window borders
cask "alt-tab"                     # Windows-style alt-tab
cask "hiddenbar"                   # Menu bar manager
cask "alcove"                      # Dynamic Island for the notch
cask "raycast"                     # Launcher

# ========================================
# Applications - Development
# ========================================
cask "ghostty"                     # Terminal
cask "cmux"                        # Claude Code terminal
cask "wezterm"                     # Terminal (backup)
cask "zed"                         # Primary editor
cask "cursor"                      # AI editor
cask "visual-studio-code"          # Editor
cask "claude"                      # Claude desktop
cask "opencode-desktop"            # opencode desktop
cask "t3-code"                     # GUI for AI code agents
cask "codexbar"                    # Codex usage in the menu bar
cask "orbstack"                    # Docker + Linux VMs
cask "android-studio"              # Android development
cask "gcloud-cli"                  # Google Cloud SDK
cask "sf-symbols"                  # Apple SF Symbols

# ========================================
# Applications - Productivity
# ========================================
cask "1password"                   # Password manager
cask "obsidian"                    # Notes (vault: ~/Learn/Notes)
cask "ticktick"                    # Tasks
cask "mimestream"                  # Gmail client
cask "meetingbar"                  # Next meeting in menu bar
cask "hyprnote@nightly"            # Meeting notes
cask "wispr-flow"                  # Dictation
cask "macwhisper"                  # Transcription
cask "shottr"                      # Screenshots
cask "localsend"                   # AirDrop alternative
cask "anki"                        # Flashcards
cask "calibre"                     # eBook library (used by `book`)
cask "setapp"                      # App subscription
cask "libreoffice"                 # Office suite
cask "microsoft-office"            # Office suite
cask "microsoft-auto-update"       # Office updater

# ========================================
# Applications - Browsers & Communication
# ========================================
cask "arc"                         # Browser
cask "google-chrome"               # Browser
cask "slack"                       # Chat
cask "discord"                     # Chat
cask "vesktop"                     # Discord client (Vencord)
cask "zoom"                        # Video calls
cask "parsec"                      # Remote desktop

# ========================================
# Applications - Media
# ========================================
cask "spotify"                     # Music (themed with Spicetify)
cask "soundsource"                 # Per-app audio
cask "screen-studio"               # Screen recording
cask "qbittorrent"                 # Torrents
cask "aerial"                      # Screensaver

# ========================================
# Applications - System
# ========================================
cask "aldente"                     # Battery charge limiter
cask "parallels"                   # VMs
cask "basictex"                    # Minimal TeX

# ========================================
# Fonts
# ========================================
cask "font-jetbrains-mono-nerd-font"  # Terminal + editor font
cask "font-sf-mono"                # Apple SF Mono
cask "font-sf-pro"                 # Apple SF Pro (Sketchybar)
cask "font-sketchybar-app-font"    # App icons in Sketchybar

# ========================================
# Mac App Store (requires App Store sign-in)
# ========================================
mas "Bitwarden", id: 1352778147
mas "Fusion 2", id: 6759285919
mas "iMovie", id: 408981434
mas "Keynote", id: 409183694
mas "Kindle", id: 302584613
mas "Numbers", id: 409203825
mas "Pages", id: 409201541
mas "Streaks", id: 963034692
mas "TestFlight", id: 899247664
mas "Xcode", id: 497799835

# ========================================
# Global npm Packages
# ========================================
npm "@google/gemini-cli"
npm "@steipete/bird"
npm "gemini-mcp-tool"
npm "neovim"
npm "tree-sitter-cli"
npm "vercel"
npm "yarn"

# ========================================
# Cargo Packages
# ========================================
cargo "claude-tmux"

# ========================================
# VS Code Extensions
# ========================================
vscode "anthropic.claude-code"
vscode "batchnepal.vscode-video-preview"
vscode "catppuccin.catppuccin-vsc"
vscode "catppuccin.catppuccin-vsc-icons"
vscode "eamodio.gitlens"
vscode "github.copilot-chat"
vscode "github.vscode-github-actions"
vscode "grapecity.gc-excelviewer"
vscode "humao.rest-client"
vscode "imzivko.cursor-dark-core"
vscode "james-yu.latex-workshop"
vscode "kevinrose.vsc-python-indent"
vscode "leetnotion.vscode-leetnotion"
vscode "mathematic.vscode-latex"
vscode "mechatroner.rainbow-csv"
vscode "mohd-akram.vscode-html-format"
vscode "mongodb.mongodb-vscode"
vscode "ms-python.debugpy"
vscode "ms-python.python"
vscode "ms-python.vscode-pylance"
vscode "ms-python.vscode-python-envs"
vscode "ms-vscode-remote.remote-ssh"
vscode "ms-vscode-remote.remote-ssh-edit"
vscode "ms-vscode-remote.remote-wsl"
vscode "ms-vscode.cmake-tools"
vscode "ms-vscode.cpp-devtools"
vscode "ms-vscode.cpptools"
vscode "ms-vscode.cpptools-extension-pack"
vscode "ms-vscode.cpptools-themes"
vscode "ms-vscode.powershell"
vscode "ms-vscode.remote-explorer"
vscode "ms-vsliveshare.vsliveshare"
vscode "oderwat.indent-rainbow"
vscode "stateful.marquee"
vscode "streetsidesoftware.code-spell-checker"
vscode "twxs.cmake"
vscode "vintharas.learn-vim"
vscode "vscodevim.vim"
vscode "zhuangtongfa.material-theme"
