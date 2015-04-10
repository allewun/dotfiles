#!/usr/bin/env zsh

#=========================
# Set up iTerm
#=========================

(
local appname="iTerm.app"
if [[ -n "$1" ]]; then
  appname="$1"
  echo "Override: modifying $appname rather than iTerm.app"
fi

echo "NOTE: iTerm2 needs to be closed"

# Remove iTerm from dock
/usr/libexec/PlistBuddy -c 'Add :LSUIElement bool true' "/Applications/${appname}/Contents/Info.plist"

# Restore iTerm in dock
# /usr/libexec/PlistBuddy -c 'Delete :LSUIElement' /Applications/iTerm.app/Contents/Info.plist

# Copy iTerm settings
cp -f "$DOTFILE_PATH/preferences/iTerm2/com.googlecode.iterm2.plist" ~/Library/Preferences/ && echo "Restored iTerm settings"

# Reload preferences (http://apple.stackexchange.com/questions/111534/iterm2-doesnt-read-com-googlecode-iterm2-plist)
defaults read com.googlecode.iterm2
killall cfprefsd
)
