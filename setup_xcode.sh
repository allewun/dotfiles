#!/usr/bin/env zsh

#=========================
# Set up Xcode
#=========================

(
  # fix ugly/barely-visible xcode i-beam cursor
  XCODE_CURSOR_PATH=/Applications/Xcode.app/Contents/SharedFrameworks/DVTKit.framework/Resources
  sudo cp "$XCODE_CURSOR_PATH/DVTIbeamCursor.tiff" "$XCODE_CURSOR_PATH/DVTIbeamCursor-backup.tiff"
  sudo cp -f "$DOTFILE_PATH/misc/cursors/DVTIbeamCursor.tiff" "$XCODE_CURSOR_PATH/"
  echo "Fixed ugly/barely-visible xcode i-beam cursor\n"

  # install xcode snippets
  local randomtempdir="$(randomtempdir)"
  mkdir "$randomtempdir"
  mv ~/Library/Developer/Xcode/UserData/CodeSnippets/* "$randomtempdir"
  echo "Old snippets temporarily backed up to $randomtempdir" | indent

  for snippet in $DOTFILE_PATH/xcode/snippets/*; do
    echo "Installing snippet \"$(basename $snippet)\""
    xcodesnippet install $snippet | indent
  done

  # install color theme
  cp "$DOTFILE_PATH/xcode/Made of Code.dvtcolortheme" ~/Library/Developer/Xcode/UserData/FontAndColorThemes
  echo "Installed Made of Code color theme"
)
