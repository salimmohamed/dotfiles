#!/bin/bash

# CPU plugin - Minimal style

# Get CPU usage from the event provider or calculate it
if [ -n "$INFO" ]; then
  CPU_USAGE="$INFO"
else
  CPU_USAGE=$(ps -A -o %cpu | awk '{s+=$1} END {printf "%.0f", s}')
fi

sketchybar --set "$NAME" icon="󰻠" label="${CPU_USAGE}%"
