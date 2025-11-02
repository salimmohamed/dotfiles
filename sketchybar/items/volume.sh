#!/bin/bash

# Volume widget

sketchybar --add item volume right \
  --set volume \
    script="$CONFIG_DIR/plugins/volume.sh" \
    icon.font="SF Pro:Semibold:16.0" \
    icon.padding_left=6 \
    icon.padding_right=4 \
    label.font="SF Pro:Semibold:14.0" \
    label.padding_left=2 \
    label.padding_right=8 \
    background.color=0xff414550 \
    background.corner_radius=5 \
    background.height=24 \
    click_script="open 'x-apple.systempreferences:com.apple.preference.sound'" \
  --subscribe volume volume_change
