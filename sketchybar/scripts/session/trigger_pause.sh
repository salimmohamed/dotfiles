#!/bin/bash
# Called by Apple Shortcut when session is paused
# Arguments: $1 = duration_second, $2 = passed_second

DURATION="${1:-0}"
PASSED="${2:-0}"

/opt/homebrew/bin/sketchybar --trigger session_paused DURATION="$DURATION" PASSED="$PASSED"
