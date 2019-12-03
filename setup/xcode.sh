#!/usr/bin/env zsh

source $DOTFILE_PATH/zsh/functions.sh

(
  THEME_DESTINATION=~/Library/Developer/Xcode/UserData/FontAndColorThemes

  # install color theme
  mkdir -p $THEME_DESTINATION
  cp "$DOTFILE_PATH/xcode/Made of Code.dvtcolortheme" $THEME_DESTINATION
  echo "* Installed Made of Code color theme ($THEME_DESTINATION)"
)
