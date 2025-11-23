#!/usr/bin/env bash

#===============================================================================
# Backup Script
#
# Backs up existing dotfiles before creating symlinks
#===============================================================================

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Directories
HOME_DIR="$HOME"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_DIR="$HOME_DIR/.dotfiles-backup-$TIMESTAMP"

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_info() {
    echo -e "${YELLOW}→${NC} $1"
}

print_header() {
    echo -e "${BLUE}$1${NC}"
}

backup_file() {
    local file="$1"
    local filename=$(basename "$file")

    if [ -e "$file" ] && [ ! -L "$file" ]; then
        mkdir -p "$BACKUP_DIR"
        cp -R "$file" "$BACKUP_DIR/$filename"
        print_info "Backed up: $filename"
        return 0
    fi
    return 1
}

#===============================================================================
# Backup Files
#===============================================================================

print_header "Backing up existing dotfiles..."
echo ""

BACKED_UP=false

# Backup shell configuration files
for file in .zshrc .zshenv .zprofile .bashrc .bash_profile; do
    if backup_file "$HOME_DIR/$file"; then
        BACKED_UP=true
    fi
done

# Backup .config directory if it exists and is not a symlink
if [ -d "$HOME_DIR/.config" ] && [ ! -L "$HOME_DIR/.config" ]; then
    backup_file "$HOME_DIR/.config"
    BACKED_UP=true
fi

# Backup git config
if [ -f "$HOME_DIR/.gitconfig" ]; then
    if backup_file "$HOME_DIR/.gitconfig"; then
        BACKED_UP=true
    fi
fi

#===============================================================================
# Summary
#===============================================================================

echo ""
if [ "$BACKED_UP" = true ]; then
    print_success "Backup completed"
    print_info "Backup location: $BACKUP_DIR"
    echo ""
    print_info "To restore from backup:"
    echo "  cp -R $BACKUP_DIR/* ~/"
else
    print_success "No files needed backup"
fi
