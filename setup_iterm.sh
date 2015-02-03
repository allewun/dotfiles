#!/usr/bin/env zsh

#=========================
# Set up iTerm
#=========================

(
echo "NOTE: iTerm needs to be closed"

# Remove iTerm from dock
/usr/libexec/PlistBuddy -c 'Add :LSUIElement bool true' /Applications/iTerm.app/Contents/Info.plist

# Restore iTerm in dock
# /usr/libexec/PlistBuddy -c 'Delete :LSUIElement' /Applications/iTerm.app/Contents/Info.plist

# Copy iTerm settings
cp -f "$DOTFILE_PATH/preferences/iTerm/com.googlecode.iterm2.plist" ~/Library/Preferences/ && echo "Restored iTerm settings"

# Reload preferences (http://apple.stackexchange.com/questions/111534/iterm2-doesnt-read-com-googlecode-iterm2-plist)
defaults read com.googlecode.iterm2
killall cfprefsd
)
