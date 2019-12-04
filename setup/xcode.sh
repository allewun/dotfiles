#!/usr/bin/env zsh

source $DOTFILE_PATH/zsh/functions.sh

(
  # install color themes
  THEME_SRC=$DOTFILE_PATH/xcode/themes/
  THEME_DEST=~/Library/Developer/Xcode/UserData/FontAndColorThemes
  mkdir -p $THEME_DEST

  for file in $THEME_SRC/*; do
    echo "* Installing $(basename $file)..."
    cp -v $file $THEME_DEST
  done

  # add duplicate line key binding
  echo
  echo "* Add \"Duplicate Line\" key binding. Specify the Xcode app filename (e.g. Xcode.app or Xcode-11.0.app):"
  ls /Applications | grep Xcode | indent 4
  read XCODE_FILENAME
  KEYBINDING_FILE="/Applications/$XCODE_FILENAME/Contents/Frameworks/IDEKit.framework/Resources/IDETextKeyBindingSet.plist"
  cp $KEYBINDING_FILE ~/Desktop/IDETextKeyBindingSet-backup.plist # backup
  sudo perl -pi -e 's/<string>selectWord:<\/string>/<string>selectWord:<\/string>\n    <key>Duplicate Selection<\/key>\n    <string>selectParagraph:, delete:, undo:, moveRight:, yankAndSelect:<\/string>/g' $KEYBINDING_FILE && echo "Done!"
)
