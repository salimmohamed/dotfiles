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
[[ -r ~/.config/theme/generated/colors.sh ]] && source ~/.config/theme/generated/colors.sh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=${THEME_OVERLAY0:-#6c7086}"
