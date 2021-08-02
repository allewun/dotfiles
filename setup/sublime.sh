#!/usr/bin/env zsh

if [[ "$OSTYPE" != "darwin"* ]]; then
  echo "Skipping Sublime setup (not on Mac)."
  echo
  echo "❌ Skipped."
  exit
fi

if [[ ! -a "/Applications/Sublime Text.app" ]]; then
  echo "Skipping Sublime setup (not yet installed)."
  echo "  * https://www.sublimetext.com/"
  echo
  echo "❌ Skipped."
  exit
fi

source "$DOTFILE_PATH/zsh/functions.sh"

SUBLIME_SRC="$DOTFILE_PATH/preferences/Sublime"
SUBLIME_DEST="$HOME/Library/Application Support/Sublime Text/Packages"

# symlink subl command
if ! which subl; then
  echo "Symlinking subl command..."
  sudo ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/subl
fi

# theme
echo "Installing Soda Theme..."
tar -xzvf "$SUBLIME_SRC/theme-soda.tar.gz" -C "$SUBLIME_DEST"

# preferences
echo "Installing user preferences..."
for file in $SUBLIME_SRC/User/*; do
  cp -v "$file" "$SUBLIME_DEST/User" | indent 4
done;

echo "✅ Done."