#!/bin/bash

# WiFi status plugin for Sketchybar (macOS Sequoia compatible)

source "$HOME/.config/sketchybar/icons.sh"

# Get WiFi interface name
WIFI_INTERFACE=$(networksetup -listallhardwareports | awk '/Wi-Fi|AirPort/{getline; print $NF}')

# Get current WiFi network using the preferred networks list
# On macOS Sequoia, the first network in this list is the one you're currently connected to
SSID=$(networksetup -listpreferredwirelessnetworks "$WIFI_INTERFACE" 2>/dev/null | grep -v '^Preferred networks on' | head -1 | sed 's/^[[:space:]]*//')

# Check if we got a valid SSID
if [ -n "$SSID" ] && [ "$SSID" != "" ]; then
  # We're connected to this network
  sketchybar --set "$NAME" icon="$ICON_WIFI" label="$SSID"
else
  # No preferred networks or not connected
  sketchybar --set "$NAME" icon="$ICON_WIFI_OFF" label="Disconnected"
fi
