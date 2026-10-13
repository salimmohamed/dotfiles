#!/usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Update Spotify + Spicetify
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🎧
# @raycast.packageName Spotify
# @raycast.description Update Spicetify and Spotify, then reapply the theme

#===============================================================================
# Spotify + Spicetify Update
#
# Premium account, so no SpotX. Order matters: Spotify must be updated before
# Spicetify backs up and patches its files.
#===============================================================================

set -eu

# Raycast runs scripts with a minimal PATH
export PATH="$HOME/.spicetify:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

APP="/Applications/Spotify.app"

spotify_version() {
    defaults read "$APP/Contents/Info.plist" CFBundleShortVersionString 2>/dev/null || echo "none"
}

print_info() {
    echo "→ $1"
}

print_success() {
    echo "✓ $1"
}

# 1. Close Spotify
if pgrep -x Spotify >/dev/null; then
    print_info "Closing Spotify"
    osascript -e 'quit app "Spotify"' >/dev/null 2>&1 || true
    sleep 3
    pgrep -x Spotify >/dev/null && killall Spotify 2>/dev/null && sleep 2
fi

# 2. Update the Spicetify CLI first so it supports the newest Spotify
print_info "Updating Spicetify CLI"
spicetify upgrade || true

# 3. Update Spotify
before=$(spotify_version)
print_info "Spotify $before, checking Homebrew"
brew upgrade --cask spotify 2>&1 | grep -vE "^Warning: Not upgrading" || true
after=$(spotify_version)

# 4. Reapply Spicetify
if [[ "$before" != "$after" ]]; then
    print_success "Spotify updated $before → $after"
    # Spicetify reads the version from Spotify's prefs, which only update
    # after a launch, so launch once before backing up
    print_info "Launching Spotify once to record the new version"
    open "$APP"
    sleep 8
    osascript -e 'quit app "Spotify"' >/dev/null 2>&1 || true
    sleep 3
    pgrep -x Spotify >/dev/null && killall Spotify 2>/dev/null && sleep 2
    # Fresh install: old backup is for the previous version, so clear it
    # (answer yes to the prompt) and back up the clean files
    print_info "Backing up new Spotify and applying theme"
    yes | spicetify -n backup apply
else
    print_success "Spotify already up to date ($after)"
    print_info "Reapplying theme"
    spicetify -n apply || yes | spicetify -n restore backup apply
fi

# 5. Stop Spotify's own updater from silently wiping the theme
spicetify -n spotify-updates block >/dev/null 2>&1 || true

# 6. Relaunch (by path: Launch Services may not know the new bundle yet)
open "$APP"
print_success "Done. Spotify $after with marketplace/mocha"
