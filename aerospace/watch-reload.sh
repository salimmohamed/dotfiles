#!/bin/bash

# Auto-reload AeroSpace config on file changes
# Usage: ./watch-reload.sh

# AeroSpace reads from ~/.aerospace.toml by default
CONFIG_FILE="$HOME/.aerospace.toml"

# Check if fswatch is installed
if ! command -v fswatch &> /dev/null; then
    echo "fswatch is not installed. Installing via Homebrew..."
    brew install fswatch
fi

echo "Watching $CONFIG_FILE for changes..."
echo "Press Ctrl+C to stop watching"
echo ""

# Watch the config file and reload on changes
fswatch -o "$CONFIG_FILE" | while read f; do
    echo "[$(date +'%H:%M:%S')] Config changed, reloading..."
    aerospace reload-config
    if [ $? -eq 0 ]; then
        echo "✓ Config reloaded successfully"
    else
        echo "✗ Failed to reload config"
    fi
    echo ""
done

