#!/usr/bin/env bash

#===============================================================================
# Symlink Management Script
#
# Creates symlinks from dotfiles repository to home directory
#===============================================================================

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Directories
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOME_DIR="$HOME"

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_info() {
    echo -e "${YELLOW}→${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

create_symlink() {
    local source="$1"
    local target="$2"

    # If target exists and is not a symlink, it should have been backed up
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        print_error "Target exists and is not a symlink: $target"
        print_info "It should have been backed up. Skipping..."
        return 1
    fi

    # Remove existing symlink if it exists
    if [ -L "$target" ]; then
        rm "$target"
        print_info "Removed old symlink: $target"
    fi

    # Create symlink
    ln -sf "$source" "$target"
    print_success "Created symlink: $target -> $source"
}

#===============================================================================
# Create .config Symlink
#===============================================================================

print_info "Setting up .config directory..."

# Backup current .config if it exists and is not a symlink
if [ -d "$HOME_DIR/.config" ] && [ ! -L "$HOME_DIR/.config" ]; then
    # This should have been handled by backup.sh
    print_error ".config directory exists but is not a symlink"
    print_info "Please run backup.sh first"
    exit 1
fi

# Remove existing .config symlink if it exists
if [ -L "$HOME_DIR/.config" ]; then
    rm "$HOME_DIR/.config"
    print_info "Removed old .config symlink"
fi

# Create symlink to entire .config directory
create_symlink "$DOTFILES_DIR" "$HOME_DIR/.config"

#===============================================================================
# Link Home Directory Files
#===============================================================================

print_info "Linking home directory files..."

if [ -d "$DOTFILES_DIR/home" ]; then
    for file in "$DOTFILES_DIR/home"/.* "$DOTFILES_DIR/home"/*; do
        # Skip . and ..
        if [ "$(basename "$file")" = "." ] || [ "$(basename "$file")" = ".." ]; then
            continue
        fi

        # Skip if file doesn't exist (glob didn't match)
        if [ ! -e "$file" ]; then
            continue
        fi

        filename=$(basename "$file")
        create_symlink "$file" "$HOME_DIR/$filename"
    done
else
    print_info "No home/ directory found, skipping..."
fi

#===============================================================================
# Summary
#===============================================================================

echo ""
print_success "Symlink creation complete!"
print_info "Your dotfiles are now managed from: $DOTFILES_DIR"
