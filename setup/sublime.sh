#!/usr/bin/env zsh

if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "Skipping Sublime setup (not on Mac)."
    exit
fi

source "$DOTFILE_PATH/zsh/functions.sh"

SUBLIME_SRC="$DOTFILE_PATH/preferences/Sublime"
SUBLIME_DEST="$HOME/Library/Application Support/Sublime Text 3/Packages"

# theme
echo "Installing Soda Theme..."
tar -xzvf "$SUBLIME_SRC/theme-soda.tar.gz" -C "$SUBLIME_DEST"

# preferences
echo "Installing user preferences..."
for file in $SUBLIME_SRC/User/*; do
  cp -v "$file" "$SUBLIME_DEST/User" | indent 4
done;
