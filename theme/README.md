# Master theme

One place to change the colors of the whole setup.

```sh
theme               # show the current theme
theme list          # list themes
theme tokyo-night   # switch (any unique part of the name works: `theme tokyo`)
theme reload        # re-apply the current theme after editing a theme file
```

## How it works

Each file in `themes/` fills the same 26 color slots (Catppuccin's slot names:
`base mantle crust surface0-2 overlay0-2 subtext0-1 text` plus the accents).
`[official]` optionally names the app's own port of the theme, which is used
instead of the generated colors for apps that have hundreds of UI colors.

`theme <name>` writes `generated/` and updates or reloads each app:

| App | Reads | Source |
|---|---|---|
| SketchyBar | `generated/sketchybar.lua` via `sketchybar/colors.lua` | palette |
| tmux | `generated/tmux.conf` (feeds the catppuccin plugin's `@thm_*`) | palette |
| JankyBorders, zsh, tmux-boot | `generated/colors.sh` | palette |
| Spotify | `spicetify/Themes/palette/color.ini` | palette |
| ccstatusline | colors rewritten in place (slot map: `apps/ccstatusline.json`) | palette |
| Ghostty | `generated/ghostty.conf` (`config-file` include) | official, else palette |
| Zed, VS Code, Obsidian | their settings files | official name (installed if missing) |

Starship uses named terminal colors, so it follows Ghostty.

## Adding a theme

Copy a file in `themes/`, change the colors, and run `theme <new-name>`.
Leave `[official]` keys out for apps that have no port of the theme; Ghostty
then uses the palette, and Zed / VS Code / Obsidian fall back to their default
dark theme.

## Notes

- Files outside this repo (VS Code settings, Obsidian `appearance.json`) are
  copied to `backups/` (git-ignored) before the first edit.
- `git reset --hard pre-theme-system` returns the repo to the state before
  this system existed.
