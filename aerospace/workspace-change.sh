#!/bin/bash
# Defer post-workspace work so AeroSpace finishes the workspace-change callback
# before SketchyBar and follow-floats start calling back into the CLI.

focused_workspace="${AEROSPACE_FOCUSED_WORKSPACE:-}"
prev_workspace="${AEROSPACE_PREV_WORKSPACE:-}"

(
  sleep 0.05

  /Users/sm/.config/aerospace/follow-floats.sh "$focused_workspace"

  if [ -z "$focused_workspace" ]; then
    focused_workspace=$(/opt/homebrew/bin/aerospace list-workspaces --focused 2>/dev/null)
  fi

  [ -n "$focused_workspace" ] || exit 0

  /opt/homebrew/bin/sketchybar --trigger aerospace_workspace_change \
    FOCUSED_WORKSPACE="$focused_workspace" \
    PREV_WORKSPACE="$prev_workspace"
) >/dev/null 2>&1 &
