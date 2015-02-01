#!/bin/zsh

#=========================
# Set up iTerm
#=========================

(
# Remove iTerm from dock
/usr/libexec/PlistBuddy -c 'Add :LSUIElement bool true' /Applications/iTerm.app/Contents/Info.plist

# Restore iTerm in dock
# /usr/libexec/PlistBuddy -c 'Delete :LSUIElement' /Applications/iTerm.app/Contents/Info.plist
)
