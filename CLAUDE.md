# Dotfiles — ~/.config

## Color Palette
- **Catppuccin Mocha** is the OS-wide color palette used across all tools
- Full reference: [catppuccin-mocha.md](catppuccin-mocha.md)
- When changing colors for any config (Ghostty, sketchybar, aerospace, lue, tmux, etc.), always use colors from this palette

## Master Theme
- All app colors come from one switchable theme: [theme/README.md](theme/README.md)
- Switch everything with `theme <name>` (catppuccin-mocha, dracula, tokyo-night, nord); themes live in `theme/themes/*.toml`
- Never hardcode hex colors in app configs: read them from `theme/generated/` (shell: `colors.sh`, SketchyBar: `colors.lua`, tmux: `@thm_*`)
