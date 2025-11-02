#!/bin/bash

# Media plugin - Minimal style, only shows when playing

STATE="$(echo "$INFO" | jq -r '.state' 2>/dev/null)"

if [ "$STATE" = "playing" ]; then
  MEDIA="$(echo "$INFO" | jq -r '.title + " - " + .artist' 2>/dev/null)"
  sketchybar --set "$NAME" icon="󰎆" label="$MEDIA" drawing=on
else
  sketchybar --set "$NAME" drawing=off
fi
