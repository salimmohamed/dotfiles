# Interactive shell configuration
# This file is sourced for interactive shells

# Source modular configuration files
[[ -f "$ZDOTDIR/config/prompt.zsh" ]] && source "$ZDOTDIR/config/prompt.zsh"
[[ -f "$ZDOTDIR/config/zoxide.zsh" ]] && source "$ZDOTDIR/config/zoxide.zsh"
[[ -f "$ZDOTDIR/config/completion.zsh" ]] && source "$ZDOTDIR/config/completion.zsh"

# Aliases (migrated from old ~/.zshrc)
alias spyder-uninstall='rm -rf ~/.spyder-py3'

# Tmux workflow
alias tb='tmux-boot'
alias rh='rehoboam'
alias c='claude'
tka() {
  tmux kill-server 2>/dev/null || true
  rm -rf ~/.local/share/tmux/resurrect 2>/dev/null || true
  killall Ghostty 2>/dev/null || true
}

# Add additional configuration files here
# Example:
# [[ -f "$ZDOTDIR/config/aliases.zsh" ]] && source "$ZDOTDIR/config/aliases.zsh"
# [[ -f "$ZDOTDIR/config/functions.zsh" ]] && source "$ZDOTDIR/config/functions.zsh"

export PATH=$PATH:$HOME/.spicetify

# Obsidian CLI
export PATH="$PATH:/Applications/Obsidian.app/Contents/MacOS"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
