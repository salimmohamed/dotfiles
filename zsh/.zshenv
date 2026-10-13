# Environment variables for zsh
# This file is sourced for all shell invocations (login, interactive, scripts)

# Add ~/.local/bin to PATH for user scripts
export PATH="$HOME/.local/bin:$PATH"

# Rust toolchain + cargo-installed binaries (claude-tmux, etc.)
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

# Add custom environment variables here
