# Login shell configuration
# This file is sourced for login shells

# Initialize Homebrew environment
eval "$(/opt/homebrew/bin/brew shellenv)"

# Add local bin to PATH (for ralph, etc.)
export PATH="$HOME/.local/bin:$PATH"

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
