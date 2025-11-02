#!/bin/bash

# Some events send additional information specific to the event in the $INFO
# variable. E.g. the front_app_switched event sends the name of the newly
# focused application in the $INFO variable:
# https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting

PLUGIN_DIR="$HOME/.config/sketchybar/plugins"

if [ "$SENDER" = "front_app_switched" ]; then
  # Get the app icon from icon_map.sh
  ICON=$("$PLUGIN_DIR/icon_map.sh" "$INFO")

  # Set only the icon, not the label
  sketchybar --set "$NAME" icon="$ICON" label=""
fi
