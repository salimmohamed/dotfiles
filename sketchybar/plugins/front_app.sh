#!/bin/bash

# Front app plugin - Shows icon for focused app

APP_NAME="$INFO"

# Get the icon for this app
APP_ICON=$("$CONFIG_DIR/plugins/icon_map_fn.sh" "$APP_NAME")

# Show just the icon (label is hidden in items config)
sketchybar --set "$NAME" icon="$APP_ICON"
