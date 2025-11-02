#!/bin/bash

# Calendar widget - Date and Time display

sketchybar --add item calendar right \
  --set calendar \
    update_freq=30 \
    icon.drawing=on \
    icon.font="SF Pro:Black:12.0" \
    icon.padding_left=8 \
    icon.padding_right=4 \
    label.font="SF Pro:Semibold:14.0" \
    label.padding_left=4 \
    label.padding_right=8 \
    label.width=85 \
    background.color=0xff414550 \
    background.corner_radius=5 \
    background.height=24 \
    click_script="open -a 'Calendar'" \
    script="$CONFIG_DIR/plugins/calendar.sh"
