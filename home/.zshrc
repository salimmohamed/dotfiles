# >>> Added by Spyder >>>
alias uninstall-spyder=/Users/sm/Library/spyder-6/uninstall-spyder.sh
# <<< Added by Spyder <<<

# ==============================================================================
# Neovim Swap File Auto-Cleanup
# ==============================================================================
# Silently clean orphaned swap files in the background on shell startup
# This ensures a clean state before opening Neovim
if [ -x "$HOME/.local/bin/nvim-clean-swaps.sh" ]; then
  "$HOME/.local/bin/nvim-clean-swaps.sh" &>/dev/null &
fi

# Optional: Manual cleanup alias
alias nvim-clean-swaps="$HOME/.local/bin/nvim-clean-swaps.sh"
