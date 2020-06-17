#!/usr/bin/env zsh

if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "Skipping Mac setup (not on Mac)."
    echo
    echo "❌ Skipped."
    exit
fi

source "$DOTFILE_PATH/zsh/functions.sh"

# install color themes
THEME_SRC="$DOTFILE_PATH/xcode/themes"
THEME_DEST=~/Library/Developer/Xcode/UserData/FontAndColorThemes
mkdir -p "$THEME_DEST"

for file in $THEME_SRC/*; do
  echo "* Installing $(basename "$file")..."
  cp -v "$file" "$THEME_DEST"
done


# install snippets
SNIPPET_SRC="$DOTFILE_PATH/xcode/snippets"
SNIPPET_DEST=~/Library/Developer/Xcode/UserData/CodeSnippets
mkdir -p "$SNIPPET_DEST"

for file in $SNIPPET_SRC/*; do
  echo "* Installing $(basename "$file")..."
  cp -v "$file" "$SNIPPET_DEST"
done


# add duplicate line key binding
echo
echo '* Add "Duplicate Line" key binding.'
echo '  Currently active:' $(xcode-select -p | grep -oE 'Xcode[^/]+')
echo '  Specify the Xcode version to add binding to (press enter to skip):\n'
ls /Applications | grep Xcode | indent 4
echo
read XCODE_FILENAME

XCODE_PATH="/Applications/$XCODE_FILENAME"
if [[ -n "$XCODE_FILENAME" && -d "$XCODE_PATH" ]]; then
  KEYBINDING_FILE="$XCODE_PATH/Contents/Frameworks/IDEKit.framework/Resources/IDETextKeyBindingSet.plist"
  cp "$KEYBINDING_FILE" ~/Desktop/IDETextKeyBindingSet-backup.plist # backup
  sudo perl -pi -e 's/<string>selectWord:<\/string>/<string>selectWord:<\/string>\n    <key>Duplicate Selection<\/key>\n    <string>selectParagraph:, delete:, undo:, moveRight:, yankAndSelect:<\/string>/g' $KEYBINDING_FILE && echo "Done!"
else
  if [[ -z "$XCODE_FILENAME" ]]; then
    echo "Skipping."
  else
    echo "Couldn't find Xcode at: \"$XCODE_PATH\". Skipping."
  fi
fi

echo "✅ Done."