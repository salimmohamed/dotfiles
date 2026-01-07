#!/bin/bash
# Called by Apple Shortcut when break starts
# Arguments: $1 = duration_second, $2 = passed_second

DURATION="${1:-0}"
PASSED="${2:-0}"

/opt/homebrew/bin/sketchybar --trigger session_break DURATION="$DURATION" PASSED="$PASSED"
