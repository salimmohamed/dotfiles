#!/bin/bash

# Calendar plugin - Updates date and time

# Date format: 'sat, nov 01' (lowercase, no periods)
DATE=$(date '+%a, %b %d' | tr '[:upper:]' '[:lower:]')

# Time format: '11:03 am' (12-hour with lowercase am/pm, no leading zero)
TIME=$(date '+%-I:%M %p' | tr '[:upper:]' '[:lower:]')

sketchybar --set "$NAME" icon="$DATE" label="$TIME"
