#!/usr/bin/env bash

#===============================================================================
# Dotfiles Bootstrap Script
#
# Sets up everything on a Mac once this repo is at ~/.config. Every step is
# idempotent, so it's also the way to bring an existing machine up to date.
# A failed step doesn't stop the rest; failures are listed at the end.
#
# Fresh Mac? Use install.sh instead (installs Xcode CLT + Homebrew, clones
# the repo, then runs this).
#
# Usage: scripts/bootstrap.sh [options]
#   --dry-run     Show what would be done without making changes
#   --skip-brew   Skip Homebrew packages (brew bundle)
#   --macos       Apply macOS defaults without asking
#   --skip-macos  Don't apply macOS defaults (and don't ask)
#===============================================================================

set -uo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"

DRY_RUN=false
SKIP_BREW=false
MACOS=ask

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

FAILED=()

#===============================================================================
# Helpers
#===============================================================================

print_header()  { echo -e "\n${BLUE}==> $1${NC}"; }
print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_error()   { echo -e "${RED}✗${NC} $1"; }
print_info()    { echo -e "${YELLOW}→${NC} $1"; }

run() {
    if [[ "$DRY_RUN" == true ]]; then
        echo -e "${YELLOW}[DRY-RUN]${NC} $*" >&2
    else
        "$@"
    fi
}

# step <name> <function>: run a step, record failure without aborting
step() {
    print_header "$1"
    if ! "$2"; then
        print_error "$1 failed (continuing)"
        FAILED+=("$1")
    fi
}

has() { command -v "$1" &>/dev/null; }

#===============================================================================
# Arguments
#===============================================================================

while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)    DRY_RUN=true ;;
        --skip-brew)  SKIP_BREW=true ;;
        --macos)      MACOS=yes ;;
        --skip-macos) MACOS=no ;;
        -h|--help)    sed -n '5,18p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0 ;;
        *)            print_error "Unknown option: $1"; exit 1 ;;
    esac
    shift
done

export DRY_RUN

if [[ "$OSTYPE" != darwin* ]]; then
    print_error "This script is for macOS only"
    exit 1
fi

# Make Homebrew available in this shell
for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    [[ -x "$brew_bin" ]] && eval "$("$brew_bin" shellenv)" && break
done
export PATH="$HOME/.local/bin:$PATH"

echo -e "${BLUE}Dotfiles:${NC} $DOTFILES_DIR"
echo -e "${BLUE}macOS:${NC}    $(sw_vers -productVersion) ($(uname -m))"
[[ "$DRY_RUN" == true ]] && print_info "DRY-RUN mode: nothing will be changed"

#===============================================================================
# Steps
#===============================================================================

# Homebrew only loads third-party tap formulae/casks once the tap is trusted.
# Trust exactly the taps the Brewfile declares.
trust_taps() {
    local taps
    taps=$(awk -F'"' '/^tap /{print $2}' "$DOTFILES_DIR/Brewfile")
    [[ -n "$taps" ]] || return 0
    # shellcheck disable=SC2086
    run brew trust --quiet --tap $taps >/dev/null
}

brew_packages() {
    if [[ "$SKIP_BREW" == true ]]; then
        print_info "Skipped (--skip-brew)"
        return 0
    fi
    if ! has brew; then
        print_error "Homebrew not installed. Run install.sh, or install it from https://brew.sh"
        return 1
    fi
    trust_taps || return 1
    print_success "Trusted Brewfile taps"
    print_info "Installing from Brewfile (this takes a while on a fresh Mac)..."
    print_info "Mac App Store apps need you to be signed in to the App Store"
    run brew bundle --file="$DOTFILES_DIR/Brewfile"
}

link_files() {
    # link.sh honors DRY_RUN itself, so it can show exactly what it would do
    bash "$DOTFILES_DIR/scripts/link.sh"
}

local_files() {
    # Private files that live in the repo dir but are gitignored
    local hooks="$DOTFILES_DIR/claude-hooks"
    if [[ ! -f "$hooks/projects.json" ]]; then
        run cp "$hooks/projects.example.json" "$hooks/projects.json"
        print_success "Created claude-hooks/projects.json (projects for tmux-boot)"
    else
        print_success "claude-hooks/projects.json exists"
    fi

    local secrets="$DOTFILES_DIR/zsh/config/secrets.zsh"
    if [[ ! -f "$secrets" ]]; then
        run cp "$secrets.example" "$secrets"
        print_success "Created zsh/config/secrets.zsh (fill in tokens)"
    else
        print_success "zsh/config/secrets.zsh exists"
    fi
}

tmux_plugins() {
    local tpm="$DOTFILES_DIR/tmux/plugins/tpm"
    if [[ ! -d "$tpm" ]]; then
        run git clone --depth 1 https://github.com/tmux-plugins/tpm "$tpm" || return 1
        print_success "Installed TPM"
    else
        print_success "TPM already installed"
    fi
    has tmux || { print_error "tmux not installed"; return 1; }
    run "$tpm/bin/install_plugins" >/dev/null && print_success "tmux plugins installed"
}

sketchybar_lua() {
    if [[ -f "$HOME/.local/share/sketchybar_lua/sketchybar.so" ]]; then
        print_success "SbarLua already installed"
        return 0
    fi
    local tmp
    tmp="$(mktemp -d)"
    run git clone --depth 1 https://github.com/FelixKratz/SbarLua.git "$tmp/SbarLua" || return 1
    if [[ "$DRY_RUN" == true ]]; then
        echo -e "${YELLOW}[DRY-RUN]${NC} make -C $tmp/SbarLua install"
    else
        (cd "$tmp/SbarLua" && make install >/dev/null) || return 1
    fi
    rm -rf "$tmp"
    print_success "SbarLua installed"
}

lue_reader() {
    if has lue; then
        print_success "lue already installed"
        return 0
    fi
    has pipx || { print_error "pipx not installed"; return 1; }
    run pipx install lue-reader && print_success "lue installed"
}

claude_code() {
    if has claude; then
        print_success "Claude Code already installed ($(claude --version 2>/dev/null | head -1))"
        return 0
    fi
    if [[ "$DRY_RUN" == true ]]; then
        echo -e "${YELLOW}[DRY-RUN]${NC} curl -fsSL https://claude.ai/install.sh | bash"
    else
        curl -fsSL https://claude.ai/install.sh | bash || return 1
    fi
    print_success "Claude Code installed"
}

spicetify_cli() {
    # config-xpui.ini stores an absolute prefs path; fix it for a different username
    local ini="$DOTFILES_DIR/spicetify/config-xpui.ini"
    if grep -q "/Users/sm/" "$ini" && [[ "$HOME" != "/Users/sm" ]]; then
        run sed -i '' "s|/Users/sm/|$HOME/|g" "$ini"
        print_info "Updated Spotify prefs path for $HOME"
    fi

    if [[ -x "$HOME/.spicetify/spicetify" ]] || has spicetify; then
        print_success "Spicetify already installed"
    elif [[ "$DRY_RUN" == true ]]; then
        echo -e "${YELLOW}[DRY-RUN]${NC} curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh"
    else
        curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh || return 1
        print_success "Spicetify installed"
    fi
    print_info "Theme is applied later (Spotify has to run once first): see the checklist below"
}

neovim_plugins() {
    has nvim || { print_error "neovim not installed"; return 1; }
    print_info "Syncing LazyVim plugins (headless)..."
    if [[ "$DRY_RUN" == true ]]; then
        echo -e "${YELLOW}[DRY-RUN]${NC} nvim --headless \"+Lazy! restore\" +qa"
        return 0
    fi
    nvim --headless "+Lazy! restore" +qa >/dev/null 2>&1 || return 1
    print_success "Neovim plugins installed"
}

launch_agents() {
    local agents="$HOME/Library/LaunchAgents"
    run mkdir -p "$agents" "$HOME/.local/log"

    for plist in "$DOTFILES_DIR"/launchd/*.plist; do
        local name label dst
        name="$(basename "$plist")"
        label="${name%.plist}"
        dst="$agents/$name"

        # The vault auto-pull only makes sense once the Obsidian vault is cloned
        if [[ "$label" == *vault-autopull && ! -d "$HOME/Learn/Notes/.git" ]]; then
            print_info "Skipping $label (no git vault at ~/Learn/Notes yet; re-run after cloning it)"
            continue
        fi

        if [[ "$DRY_RUN" == true ]]; then
            echo -e "${YELLOW}[DRY-RUN]${NC} install $dst and launchctl bootstrap gui/$(id -u)"
            continue
        fi
        sed "s|__HOME__|$HOME|g" "$plist" > "$dst"
        launchctl bootout "gui/$(id -u)/$label" 2>/dev/null || true
        launchctl bootstrap "gui/$(id -u)" "$dst" || return 1
        print_success "Loaded $label"
    done
}

services() {
    has brew || return 1
    local svc ok=0
    for svc in sketchybar borders; do
        if pgrep -x "$svc" >/dev/null; then
            print_success "$svc already running"
        elif brew list --formula "$svc" &>/dev/null; then
            if trust_taps && run brew services start "$svc" >/dev/null; then
                print_success "Started $svc"
            else
                ok=1
            fi
        else
            print_error "$svc not installed"; ok=1
        fi
    done
    return $ok
}

macos_defaults() {
    if [[ "$MACOS" == ask ]]; then
        if [[ -t 0 ]]; then
            read -r -p "Apply macOS system defaults (keyboard, Finder, Dock, menu bar)? [y/N] " reply
            [[ "$reply" =~ ^[Yy]$ ]] && MACOS=yes || MACOS=no
        else
            MACOS=no
        fi
    fi
    if [[ "$MACOS" != yes ]]; then
        print_info "Skipped (run later with: ~/.config/macos/defaults.sh)"
        return 0
    fi
    run bash "$DOTFILES_DIR/macos/defaults.sh"
}

#===============================================================================
# Run
#===============================================================================

step "Homebrew packages"    brew_packages
step "Symlinks"             link_files
step "Local config files"   local_files
step "tmux plugins"         tmux_plugins
step "SbarLua (Sketchybar)" sketchybar_lua
step "lue (eBook reader)"   lue_reader
step "Claude Code"          claude_code
step "Spicetify"            spicetify_cli
step "Neovim plugins"       neovim_plugins
step "Launch agents"        launch_agents
step "Services"             services
step "macOS defaults"       macos_defaults

#===============================================================================
# Summary
#===============================================================================

print_header "Done"

if [[ ${#FAILED[@]} -gt 0 ]]; then
    print_error "These steps failed: ${FAILED[*]}"
    print_info "Fix the cause, then re-run: ~/.config/scripts/bootstrap.sh (it's safe to repeat)"
else
    print_success "All steps completed"
fi

echo -e "\n${BLUE}Manual steps (things that need a click or a sign-in):${NC}"
cat <<EOF
  1. Open a new terminal (Ghostty) so zsh picks up the new config
  2. Open AeroSpace, AltTab, Hidden Bar, Raycast and grant Accessibility access
     (System Settings → Privacy & Security → Accessibility)
  3. Raycast: replace Spotlight (⌘Space), and add the script commands folder
     ~/.config/scripts/raycast-commands (Settings → Extensions → + → Add Script Directory)
  4. Sign in: 1Password, gh (gh auth login && gh auth setup-git), Claude Code (claude)
  5. Spotify: open it once, sign in, quit, then: spicetify backup apply
  6. Fill in tokens in ~/.config/zsh/config/secrets.zsh
  7. Clone your Obsidian vault to ~/Learn/Notes, then re-run this script to
     enable the vault auto-pull agent
  8. Log out and back in so macOS defaults (menu bar, Dock) fully apply
EOF
