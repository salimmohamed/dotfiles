#!/usr/bin/env bash
# Update sketchybar-app-font and its app-name -> icon map to the latest release.
set -euo pipefail

DIR="$(cd "$(dirname "$0")/.." && pwd)"
REPO="kvndrsslr/sketchybar-app-font"

brew upgrade --cask font-sketchybar-app-font 2>/dev/null || brew install --cask font-sketchybar-app-font

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT
curl -fsSL "https://github.com/$REPO/releases/latest/download/icon_map.lua" -o "$tmp"
grep -q '^return {' "$tmp" || { echo "Downloaded icon map looks wrong" >&2; exit 1; }
mv "$tmp" "$DIR/helpers/app_icons.lua"

echo "Updated to $(curl -fsSLI -o /dev/null -w '%{url_effective}' "https://github.com/$REPO/releases/latest" | sed 's|.*/||')"
sketchybar --reload
