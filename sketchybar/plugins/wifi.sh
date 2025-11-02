#!/bin/bash

# WiFi plugin - Minimal style

# Get current WiFi SSID
SSID=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk '/ SSID/ {print substr($0, index($0, $2))}')

if [ -z "$SSID" ]; then
  ICON="󰖪"
  LABEL="Offline"
else
  ICON="󰖩"
  LABEL="$SSID"
fi

sketchybar --set "$NAME" icon="$ICON" label="$LABEL"
