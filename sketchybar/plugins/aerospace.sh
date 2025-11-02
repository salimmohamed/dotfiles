#!/usr/bin/env bash

# Aerospace plugin - DuroCodes exact implementation
# Shows app icons for windows in each workspace

FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)

update_workspace_icon() {
    local workspace_id=$1

    # Get all windows in this workspace and map to icons
    local APP_ICONS=$(aerospace list-windows --workspace "$workspace_id" 2>/dev/null |
        awk -F '|' '{print $2}' |
        while read -r app_name; do
            "$CONFIG_DIR/plugins/icon_map_fn.sh" "$app_name"
        done | tr '\n' ' ')

    # Trim whitespace
    APP_ICONS=$(echo "$APP_ICONS" | xargs)

    # Show circle for empty workspaces
    if [ -z "$APP_ICONS" ]; then
        APP_ICONS="⏺︎"
    fi

    # Highlight focused workspace (works for empty workspaces too)
    if [ "$workspace_id" = "$FOCUSED_WORKSPACE" ]; then
        sketchybar --set "$NAME" label="$APP_ICONS" background.drawing=on
    else
        sketchybar --set "$NAME" label="$APP_ICONS" background.drawing=off
    fi
}

update_workspace_icon $1
