#!/usr/bin/env bash

#===============================================================================
# Dotfiles Bootstrap Script
#
# This script sets up your dotfiles on a fresh macOS installation.
# Run with: ./scripts/bootstrap.sh
#
# Options:
#   --dry-run    Show what would be done without making changes
#   --skip-brew  Skip Homebrew installation and bundle
#   --skip-macos Skip macOS defaults configuration
#===============================================================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Flags
DRY_RUN=false
SKIP_BREW=false
SKIP_MACOS=false

#===============================================================================
# Helper Functions
#===============================================================================

print_header() {
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${YELLOW}→${NC} $1"
}

run_command() {
    if [ "$DRY_RUN" = true ]; then
        echo -e "${YELLOW}[DRY-RUN]${NC} $1"
    else
        eval "$1"
    fi
}

#===============================================================================
# Parse Arguments
#===============================================================================

while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            print_info "Running in DRY-RUN mode"
            shift
            ;;
        --skip-brew)
            SKIP_BREW=true
            shift
            ;;
        --skip-macos)
            SKIP_MACOS=true
            shift
            ;;
        *)
            print_error "Unknown option: $1"
            exit 1
            ;;
    esac
done

#===============================================================================
# Verify macOS
#===============================================================================

print_header "Verifying System"

if [[ "$OSTYPE" != "darwin"* ]]; then
    print_error "This script is designed for macOS only"
    exit 1
fi

print_success "Running on macOS $(sw_vers -productVersion)"

#===============================================================================
# Install Homebrew
#===============================================================================

if [ "$SKIP_BREW" = false ]; then
    print_header "Installing Homebrew"

    if ! command -v brew &> /dev/null; then
        print_info "Homebrew not found, installing..."
        run_command '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'

        # Add Homebrew to PATH for Apple Silicon
        if [[ $(uname -m) == 'arm64' ]]; then
            run_command 'eval "$(/opt/homebrew/bin/brew shellenv)"'
        fi

        print_success "Homebrew installed"
    else
        print_success "Homebrew already installed"
    fi

    # Install packages from Brewfile
    print_info "Installing packages from Brewfile..."
    run_command "brew bundle --file='$DOTFILES_DIR/Brewfile'"
    print_success "Packages installed"
else
    print_info "Skipping Homebrew installation"
fi

#===============================================================================
# Backup Existing Dotfiles
#===============================================================================

print_header "Backup Existing Dotfiles"

run_command "bash '$DOTFILES_DIR/scripts/backup.sh'"
print_success "Backup completed"

#===============================================================================
# Create Symlinks
#===============================================================================

print_header "Creating Symlinks"

run_command "bash '$DOTFILES_DIR/scripts/symlink.sh'"
print_success "Symlinks created"

#===============================================================================
# Install User Scripts
#===============================================================================

print_header "Installing User Scripts"

if [ -d "$DOTFILES_DIR/scripts/bin" ]; then
    run_command "mkdir -p '$HOME/.local/bin'"
    for script in "$DOTFILES_DIR/scripts/bin"/*; do
        if [ -f "$script" ]; then
            filename=$(basename "$script")
            run_command "cp '$script' '$HOME/.local/bin/$filename'"
            run_command "chmod +x '$HOME/.local/bin/$filename'"
            print_success "Installed: $filename"
        fi
    done
else
    print_info "No scripts/bin directory found, skipping..."
fi

#===============================================================================
# Install Tmux Plugin Manager (TPM)
#===============================================================================

print_header "Installing Tmux Plugin Manager"

TPM_DIR="$HOME/.config/tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
    print_info "Installing TPM..."
    run_command "git clone https://github.com/tmux-plugins/tpm '$TPM_DIR'"
    print_success "TPM installed"
else
    print_success "TPM already installed"
fi

# Install tmux plugins
if [ -x "$TPM_DIR/bin/install_plugins" ]; then
    print_info "Installing tmux plugins..."
    run_command "'$TPM_DIR/bin/install_plugins'"
    print_success "Tmux plugins installed"
fi

#===============================================================================
# macOS Defaults
#===============================================================================

if [ "$SKIP_MACOS" = false ]; then
    print_header "macOS System Defaults"

    read -p "Apply macOS system defaults? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        run_command "bash '$DOTFILES_DIR/macos/defaults.sh'"
        print_success "macOS defaults applied"
        print_info "Some changes require a restart to take effect"
    else
        print_info "Skipping macOS defaults"
    fi
else
    print_info "Skipping macOS defaults"
fi

#===============================================================================
# Finish
#===============================================================================

print_header "Installation Complete!"

print_success "Dotfiles installed successfully"
echo ""
print_info "Next steps:"
echo "  1. Restart your terminal"
echo "  2. Review the README.md for customization options"
echo "  3. Update local configuration files (*.local)"
echo ""

if [ "$DRY_RUN" = true ]; then
    print_info "This was a DRY-RUN. No changes were made."
fi
