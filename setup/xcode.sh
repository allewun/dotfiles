#!/usr/bin/env zsh

source $DOTFILE_PATH/zsh/functions.sh

(
  THEME_SRC=$DOTFILE_PATH/xcode/themes/
  THEME_DEST=~/Library/Developer/Xcode/UserData/FontAndColorThemes

  # install color themes
  mkdir -p $THEME_DEST

  for file in $THEME_SRC/*; do
    echo "* Installing $(basename $file)..."
    cp -v $file $THEME_DEST
  done
)
