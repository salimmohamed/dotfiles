# Interactive shell configuration
# This file is sourced for interactive shells

# Source modular configuration files
[[ -f "$ZDOTDIR/config/prompt.zsh" ]] && source "$ZDOTDIR/config/prompt.zsh"
[[ -f "$ZDOTDIR/config/zoxide.zsh" ]] && source "$ZDOTDIR/config/zoxide.zsh"

# Aliases (migrated from old ~/.zshrc)
alias spyder-uninstall='rm -rf ~/.spyder-py3'

# Add additional configuration files here
# Example:
# [[ -f "$ZDOTDIR/config/aliases.zsh" ]] && source "$ZDOTDIR/config/aliases.zsh"
# [[ -f "$ZDOTDIR/config/functions.zsh" ]] && source "$ZDOTDIR/config/functions.zsh"
