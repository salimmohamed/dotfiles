#!/bin/bash
# Query Session status via Apple Shortcut and update sketchybar
# This script should be called periodically by sketchybar

# Check if Session is running
if ! pgrep -x "Session" > /dev/null; then
    /opt/homebrew/bin/sketchybar --trigger session_idle
    exit 0
fi

# Run the Shortcut to get current session info
# The Shortcut should output: state|duration|remaining
# e.g., "focus|1500|1200" or "break|300|180" or "idle|0|0"
OUTPUT=$(shortcuts run "sketchybar_session" 2>/dev/null)

if [ -z "$OUTPUT" ] || [ "$OUTPUT" = "idle" ]; then
    /opt/homebrew/bin/sketchybar --trigger session_idle
    exit 0
fi

# Parse output: state|duration|remaining
STATE=$(echo "$OUTPUT" | cut -d'|' -f1)
DURATION=$(echo "$OUTPUT" | cut -d'|' -f2)
REMAINING=$(echo "$OUTPUT" | cut -d'|' -f3)

case "$STATE" in
    focus)
        /opt/homebrew/bin/sketchybar --trigger session_focus DURATION="$DURATION" REMAINING="$REMAINING"
        ;;
    break)
        /opt/homebrew/bin/sketchybar --trigger session_break DURATION="$DURATION" REMAINING="$REMAINING"
        ;;
    paused)
        /opt/homebrew/bin/sketchybar --trigger session_paused DURATION="$DURATION" REMAINING="$REMAINING"
        ;;
    *)
        /opt/homebrew/bin/sketchybar --trigger session_idle
        ;;
esac
