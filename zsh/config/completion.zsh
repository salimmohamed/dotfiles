# Zsh Autosuggestions
# Fish-like autosuggestions for zsh
# https://github.com/zsh-users/zsh-autosuggestions

# Source the plugin (Homebrew location)
_zas="${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
[[ -f "$_zas" ]] && source "$_zas"
unset _zas

# Strategy: try history first, then completion engine
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Suggestion color (subtle gray)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666"
