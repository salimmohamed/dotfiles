#!/bin/bash
# Moves floating app windows to the current workspace when switching workspaces

current_workspace=$(aerospace list-workspaces --focused)

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
  aerospace list-windows --app-id "$app_id" 2>/dev/null | awk '{print $1}' | while read window_id; do
    [ -n "$window_id" ] && aerospace move-node-to-workspace --window-id "$window_id" "$current_workspace" 2>/dev/null
  done
done
