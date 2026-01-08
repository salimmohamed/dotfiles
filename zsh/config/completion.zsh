# Zsh Autosuggestions
# Fish-like autosuggestions for zsh
# https://github.com/zsh-users/zsh-autosuggestions

# Source the plugin (Homebrew location)
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Strategy: try history first, then completion engine
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Suggestion color (subtle gray)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666"
