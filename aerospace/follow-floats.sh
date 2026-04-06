#!/bin/bash
# Moves floating app windows to the current workspace when switching workspaces

current_workspace="${1:-$(/opt/homebrew/bin/aerospace list-workspaces --focused 2>/dev/null)}"
[ -n "$current_workspace" ] || exit 0

# List of floating app IDs (from aerospace.toml)
floating_apps=(
  "com.apple.ScreenContinuity"
  "com.cisco.secureclient.gui"
  "unity.Blizzard Entertainment.Hearthstone"
  "net.hearthsim.hstracker"
  "org.python.python"
  "com.apple.reminders"
  "org.qbittorrent.qBittorrent"
  "ai.slipbox.macos.app"
  "com.apple.finder"

  "com.timpler.screenstudio"
  "com.apple.systempreferences"
)

for app_id in "${floating_apps[@]}"; do
  while read -r window_id; do
    [ -n "$window_id" ] || continue
    /opt/homebrew/bin/aerospace move-node-to-workspace --window-id "$window_id" "$current_workspace" 2>/dev/null
  done < <(/opt/homebrew/bin/aerospace list-windows --app-id "$app_id" --format '%{window-id}' 2>/dev/null)
done
