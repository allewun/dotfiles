#!/usr/bin/env zsh

source $DOTFILE_PATH/zsh/functions.sh

(
  # install color theme
  cp "$DOTFILE_PATH/xcode/Made of Code.dvtcolortheme" ~/Library/Developer/Xcode/UserData/FontAndColorThemes
  echo "* Installed Made of Code color theme (~/Library/Developer/Xcode/UserData/FontAndColorThemes)"
)
