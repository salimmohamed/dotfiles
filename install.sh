#!/usr/bin/env bash

#===============================================================================
# Fresh Mac installer
#
#   curl -fsSL https://raw.githubusercontent.com/salimmohamed/dotfiles/master/install.sh | bash
#
# 1. Installs Xcode Command Line Tools (needed for git)
# 2. Installs Homebrew
# 3. Clones this repo into ~/.config (existing files there are backed up)
# 4. Runs scripts/bootstrap.sh (packages, symlinks, plugins, services)
#
# Arguments are passed through to bootstrap.sh, e.g.:
#   curl -fsSL .../install.sh | bash -s -- --macos
#===============================================================================

set -euo pipefail

REPO_URL="${DOTFILES_REPO:-https://github.com/salimmohamed/dotfiles.git}"
BRANCH="${DOTFILES_BRANCH:-master}"
DEST="$HOME/.config"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header()  { echo -e "\n${BLUE}==> $1${NC}"; }
print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_error()   { echo -e "${RED}✗${NC} $1"; }
print_info()    { echo -e "${YELLOW}→${NC} $1"; }

if [[ "$OSTYPE" != darwin* ]]; then
    print_error "This installer is for macOS only"
    exit 1
fi

# When piped from curl, stdin is the script itself; prompts must read the terminal
TTY=/dev/tty
( : < "$TTY" ) 2>/dev/null || TTY=/dev/null

#===============================================================================
# sudo (Homebrew needs it once; keep it alive for the whole install)
#===============================================================================

print_header "Administrator access"
print_info "Your password is needed to install Homebrew and system tools"
# The redirect feeds sudo its password prompt from the terminal
# shellcheck disable=SC2024
sudo -v < "$TTY"
while true; do sudo -n true; sleep 50; kill -0 "$$" || exit; done 2>/dev/null &

#===============================================================================
# Xcode Command Line Tools
#===============================================================================

print_header "Xcode Command Line Tools"
if xcode-select -p &>/dev/null; then
    print_success "Already installed"
else
    xcode-select --install 2>/dev/null || true
    print_info "Click \"Install\" in the dialog that just opened. Waiting for it to finish..."
    until xcode-select -p &>/dev/null; do sleep 10; done
    print_success "Installed"
fi

#===============================================================================
# Homebrew
#===============================================================================

print_header "Homebrew"
if [[ -x /opt/homebrew/bin/brew || -x /usr/local/bin/brew ]]; then
    print_success "Already installed"
else
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    print_success "Installed"
fi
for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    [[ -x "$brew_bin" ]] && eval "$("$brew_bin" shellenv)" && break
done

#===============================================================================
# Clone into ~/.config
#===============================================================================

print_header "Dotfiles → $DEST"
if git -C "$DEST" rev-parse --is-inside-work-tree &>/dev/null; then
    print_success "Repo already present"
    if [[ -z "$(git -C "$DEST" status --porcelain)" ]]; then
        if git -C "$DEST" pull -q --ff-only; then
            print_success "Pulled latest"
        else
            print_info "Couldn't fast-forward, continuing with the current checkout"
        fi
    else
        print_info "Local changes present, not pulling"
    fi
else
    # ~/.config usually already has a few app folders on a new Mac. Back the
    # whole thing up, then check the repo out on top of it so those stay put.
    if [[ -d "$DEST" ]] && [[ -n "$(ls -A "$DEST")" ]]; then
        backup="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
        mkdir -p "$backup"
        cp -R "$DEST" "$backup/"
        print_info "Backed up existing ~/.config to ${backup/#$HOME/~}/.config"
    fi
    mkdir -p "$DEST"
    git -C "$DEST" init -q -b "$BRANCH"
    git -C "$DEST" remote add origin "$REPO_URL"
    git -C "$DEST" fetch -q origin "$BRANCH"
    git -C "$DEST" reset -q --hard "origin/$BRANCH"
    git -C "$DEST" branch -q --set-upstream-to="origin/$BRANCH"
    print_success "Cloned $REPO_URL"
fi

#===============================================================================
# Bootstrap
#===============================================================================

exec bash "$DEST/scripts/bootstrap.sh" "$@" < "$TTY"
