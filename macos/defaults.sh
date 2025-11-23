#!/usr/bin/env bash

#===============================================================================
# macOS System Defaults
#
# Sets macOS system preferences via defaults command
# Customize these to your preferences
#
# CAUTION: Some settings require logout/restart to take effect
#===============================================================================

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_info() {
    echo -e "${YELLOW}→${NC} $1"
}

print_header() {
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}\n"
}

# Close System Preferences to prevent overriding changes
osascript -e 'tell application "System Preferences" to quit'

#===============================================================================
# General UI/UX
#===============================================================================

print_header "General UI/UX"

# Disable the "Are you sure you want to open this application?" dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false
print_success "Disabled app quarantine dialog"

# Disable automatic termination of inactive apps
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true
print_success "Disabled automatic app termination"

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
print_success "Set default save location to disk"

# Disable the crash reporter
defaults write com.apple.CrashReporter DialogType -string "none"
print_success "Disabled crash reporter dialog"

#===============================================================================
# Keyboard & Input
#===============================================================================

print_header "Keyboard & Input"

# Set blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
print_success "Set fast keyboard repeat rate"

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
print_success "Disabled auto-correct"

# Disable automatic capitalization
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
print_success "Disabled automatic capitalization"

# Disable smart dashes
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
print_success "Disabled smart dashes"

# Disable smart quotes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
print_success "Disabled smart quotes"

# Disable period substitution
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
print_success "Disabled period substitution"

#===============================================================================
# Trackpad, Mouse, Bluetooth
#===============================================================================

print_header "Trackpad & Mouse"

# Enable tap to click for this user and login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
print_success "Enabled tap to click"

# Enable three-finger drag
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
print_success "Enabled three-finger drag"

#===============================================================================
# Finder
#===============================================================================

print_header "Finder"

# Show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true
print_success "Show hidden files"

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
print_success "Show all file extensions"

# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true
print_success "Show status bar"

# Show path bar
defaults write com.apple.finder ShowPathbar -bool true
print_success "Show path bar"

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true
print_success "Keep folders on top"

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
print_success "Search current folder by default"

# Disable warning when changing file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
print_success "Disabled extension change warning"

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
print_success "Disabled .DS_Store on network/USB volumes"

# Use list view in all Finder windows by default
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
print_success "Set list view as default"

# Show the ~/Library folder
chflags nohidden ~/Library
print_success "Unhid ~/Library folder"

# Show the /Volumes folder
sudo chflags nohidden /Volumes
print_success "Unhid /Volumes folder"

#===============================================================================
# Dock
#===============================================================================

print_header "Dock"

# Set the icon size of Dock items
defaults write com.apple.dock tilesize -int 48
print_success "Set Dock icon size to 48"

# Don't automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false
print_success "Disabled automatic Space rearranging"

# Don't show recent applications in Dock
defaults write com.apple.dock show-recents -bool false
print_success "Disabled recent apps in Dock"

# Hot corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# Top left screen corner → Mission Control
defaults write com.apple.dock wvous-tl-corner -int 2
defaults write com.apple.dock wvous-tl-modifier -int 0
print_success "Set top-left hot corner to Mission Control"

#===============================================================================
# Screenshots
#===============================================================================

print_header "Screenshots"

# Save screenshots to Downloads folder
defaults write com.apple.screencapture location -string "${HOME}/Downloads"
print_success "Save screenshots to Downloads"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"
print_success "Set screenshot format to PNG"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true
print_success "Disabled screenshot shadows"

#===============================================================================
# Menu Bar
#===============================================================================

print_header "Menu Bar"

# Show battery percentage
defaults write com.apple.menuextra.battery ShowPercent -string "YES"
print_success "Show battery percentage"

# Show date and time in menu bar
defaults write com.apple.menuextra.clock DateFormat -string "EEE d MMM HH:mm"
print_success "Set menu bar clock format"

#===============================================================================
# Activity Monitor
#===============================================================================

print_header "Activity Monitor"

# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true
print_success "Show main window on launch"

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0
print_success "Show all processes"

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0
print_success "Sort by CPU usage"

#===============================================================================
# Terminal
#===============================================================================

print_header "Terminal"

# Only use UTF-8 in Terminal.app
defaults write com.apple.terminal StringEncodings -array 4
print_success "Set Terminal to UTF-8"

#===============================================================================
# Apply Changes
#===============================================================================

print_header "Applying Changes"

# Restart affected applications
for app in "Dock" "Finder" "SystemUIServer"; do
    killall "${app}" &> /dev/null || true
done
print_success "Restarted affected applications"

echo ""
print_info "macOS defaults applied successfully!"
print_info "Some changes may require a logout/restart to take effect"
