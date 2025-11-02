#!/bin/bash

# WiFi status plugin for Sketchybar (macOS 15+ compatible)

source "$HOME/.config/sketchybar/icons.sh"

# Get WiFi interface name
WIFI_INTERFACE=$(networksetup -listallhardwareports | awk '/Wi-Fi|AirPort/{getline; print $NF}')

# Try to get SSID using airport utility (most reliable on macOS)
SSID=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk '/ SSID/ {print substr($0, index($0, $2))}')

# Fallback to networksetup if airport didn't work
if [ -z "$SSID" ] || [ "$SSID" = "<redacted>" ]; then
  SSID=$(networksetup -getairportnetwork "$WIFI_INTERFACE" 2>/dev/null | sed 's/Current Wi-Fi Network: //')
fi

# Check if connected
if [ -n "$SSID" ] && [ "$SSID" != "You are not associated with an AirPort network." ] && [ "$SSID" != "<redacted>" ]; then
  sketchybar --set "$NAME" icon="$ICON_WIFI" label="$SSID"
else
  # Disconnected or no WiFi
  sketchybar --set "$NAME" icon="$ICON_WIFI_OFF" label="Disconnected"
fi
