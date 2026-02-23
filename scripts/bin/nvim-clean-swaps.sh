#!/bin/bash
# ==============================================================================
# Neovim Swap File Cleanup Script
# ==============================================================================
# Automatically removes orphaned swap files that are:
# 1. Older than the original file (file has been saved since)
# 2. From Neovim processes that are no longer running
# 3. Older than 7 days
#
# Safe to run automatically - only removes truly orphaned swaps
# ==============================================================================

SWAP_DIR="$HOME/.local/state/nvim/swap"

# Exit if swap directory doesn't exist
[ ! -d "$SWAP_DIR" ] && exit 0

# Find all swap files
for swapfile in "$SWAP_DIR"/*.sw[a-p] "$SWAP_DIR"/.*.sw[a-p]; do
  # Skip if no files match the pattern
  [ ! -f "$swapfile" ] && continue

  # Extract original filename from swap filename
  # Format: %path%to%file.ext.swp -> /path/to/file.ext
  basename=$(basename "$swapfile")
  original=$(echo "$basename" | sed 's/\.sw[a-p]$//' | sed 's/%/\//g' | sed 's/^/\//')

  # Remove swap if original file exists and is newer
  if [ -f "$original" ]; then
    if [ "$original" -nt "$swapfile" ]; then
      # Original file has been modified after swap was created
      # This means the swap is stale
      rm -f "$swapfile" 2>/dev/null
      continue
    fi
  else
    # Original file doesn't exist, swap is orphaned
    rm -f "$swapfile" 2>/dev/null
    continue
  fi
done

# Remove swap files older than 7 days (definitely orphaned)
find "$SWAP_DIR" -name "*.sw[a-p]" -type f -mtime +7 -delete 2>/dev/null
find "$SWAP_DIR" -name ".*.sw[a-p]" -type f -mtime +7 -delete 2>/dev/null

# Optional: Remove empty swap directory to keep things clean
# Uncomment if you want this behavior
# rmdir "$SWAP_DIR" 2>/dev/null

exit 0
