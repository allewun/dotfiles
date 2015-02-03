#!/usr/bin/env zsh

# http://www.brooksandrus.com/blog/2010/05/17/hide-show-mac-os-x-desktop-icons/

# checks visibility and stores value in a variable
isVisible="$(defaults read com.apple.finder CreateDesktop)"

# toggle desktop icon visibility based on variable
if [ "$isVisible" = 1 ]
then
defaults write com.apple.finder CreateDesktop -bool false
else
defaults write com.apple.finder CreateDesktop -bool true
fi

# force changes by restarting Finder
killall Finder
