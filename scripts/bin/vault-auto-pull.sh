#!/bin/bash
cd "$HOME/Learn/Notes" || exit 1

# Only pull if on main branch
branch=$(git symbolic-ref --short HEAD 2>/dev/null)
[ "$branch" = "main" ] || exit 0

# Only pull if working tree is clean (avoid conflicts)
git diff --quiet && git diff --cached --quiet || exit 0

# Fetch and pull only if there are upstream changes
git fetch origin main --quiet
LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/main)
if [ "$LOCAL" != "$REMOTE" ]; then
    git pull --ff-only origin main --quiet
fi
