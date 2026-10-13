#!/usr/bin/env bash

#===============================================================================
# Link Script
#
# Symlinks dotfiles into place. Safe to re-run: anything already linked is
# skipped, and any real file in the way is moved to ~/.dotfiles-backup-<ts>/
# (unless it's byte-identical, in which case it's just replaced).
#
#   ~/.config            → this repo (only if the repo lives somewhere else)
#   ~/<file>             → home/<file>        (e.g. ~/.zshenv)
#   ~/.local/bin/<file>  → scripts/bin/<file> (tmux-boot, etc.)
#
# Usage: scripts/link.sh [--dry-run]
#===============================================================================

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
DRY_RUN="${DRY_RUN:-false}"
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=true

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_info()    { echo -e "${YELLOW}→${NC} $1"; }

run() {
    if [[ "$DRY_RUN" == true ]]; then
        echo -e "${YELLOW}[DRY-RUN]${NC} $*"
    else
        "$@"
    fi
}

# link <source> <target>
link() {
    local src="$1" dst="$2"

    if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
        print_success "Already linked: ${dst/#$HOME/~}"
        return
    fi

    if [[ -L "$dst" ]]; then
        run rm "$dst"
    elif [[ -f "$src" && -f "$dst" ]] && cmp -s "$src" "$dst"; then
        run rm "$dst"
    elif [[ -e "$dst" ]]; then
        run mkdir -p "$BACKUP_DIR"
        run mv "$dst" "$BACKUP_DIR/"
        print_info "Backed up ${dst/#$HOME/~} → ${BACKUP_DIR/#$HOME/~}/"
    fi

    run mkdir -p "$(dirname "$dst")"
    run ln -s "$src" "$dst"
    print_success "Linked: ${dst/#$HOME/~} → ${src/#$HOME/~}"
}

# ~/.config: the repo is meant to live here. If it was cloned elsewhere,
# point ~/.config at it.
if [[ "$DOTFILES_DIR" != "$(cd "$HOME/.config" 2>/dev/null && pwd -P)" ]]; then
    link "$DOTFILES_DIR" "$HOME/.config"
fi

# Home directory dotfiles
shopt -s dotglob nullglob
for file in "$DOTFILES_DIR"/home/*; do
    link "$file" "$HOME/$(basename "$file")"
done

# User scripts
for file in "$DOTFILES_DIR"/scripts/bin/*; do
    [[ -f "$file" ]] && link "$file" "$HOME/.local/bin/$(basename "$file")"
done
