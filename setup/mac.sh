#!/usr/bin/env zsh

#==============================================================================
# macOS settings
# initially based on: github.com/mathiasbynens/dotfiles/blob/master/.osx
#==============================================================================

if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "Skipping Mac setup (not on Mac)."
    exit
fi

#======================================
# General
#======================================

# always show scrollbars
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

# expand save panel
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# expand print panel
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

# show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

#======================================
# Trackpad/mouse/keyboard/input
#======================================

# disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 25

# Turn off keyboard illumination when computer is not used for 5 minutes
defaults write com.apple.BezelServices kDimTime -int 300

# disable automatically inserting a period with double-spaces
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

#======================================
# Finder
#======================================

# show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# show path bar
defaults write com.apple.finder ShowPathbar -bool true

# display full path in window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES

# search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# allow text selection in QuickLook
defaults write com.apple.finder QLEnableTextSelection -bool true

# show hidden files
defaults write com.apple.finder AppleShowAllFiles true

# show the ~/Library folder
chflags nohidden ~/Library

#======================================
# Misc
#======================================

# avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# accessibility zoom with command key
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.universalaccess closeViewSmoothImages -bool false
defaults write com.apple.universalaccess closeViewScrollWheelModifiersInt -int 1048576


killall Finder
killall SystemUIServer
killall Dock

echo "✅ Done."
