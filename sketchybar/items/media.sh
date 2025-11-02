#!/bin/bash

# Media widget - Shows currently playing media (Spotify, Apple Music, etc.)

sketchybar --add item media right \
  --set media \
    icon="󰎆" \
    icon.font="SF Pro:Semibold:16.0" \
    icon.padding_left=6 \
    icon.padding_right=4 \
    icon.color=0xff1db954 \
    label.font="SF Pro:Semibold:14.0" \
    label.padding_left=2 \
    label.padding_right=8 \
    label.max_chars=20 \
    background.color=0xff414550 \
    background.corner_radius=5 \
    background.height=24 \
    background.drawing=off \
    scroll_texts=on \
    script="$CONFIG_DIR/plugins/media.sh" \
  --subscribe media media_change
