#!/bin/bash

# CPU widget

sketchybar --add item cpu right \
  --set cpu \
    update_freq=2 \
    icon="󰻠" \
    icon.font="SF Pro:Semibold:16.0" \
    icon.padding_left=6 \
    icon.padding_right=4 \
    label.font="SF Pro:Semibold:14.0" \
    label.padding_left=2 \
    label.padding_right=8 \
    background.color=0xff414550 \
    background.corner_radius=5 \
    background.height=24 \
    script="$CONFIG_DIR/plugins/cpu.sh"

# Start CPU load event provider if it exists
if [ -f "$CONFIG_DIR/helpers/event_providers/cpu_load/bin/cpu_load" ]; then
  "$CONFIG_DIR/helpers/event_providers/cpu_load/bin/cpu_load" cpu_update 2.0 &
  sketchybar --subscribe cpu cpu_update
fi
