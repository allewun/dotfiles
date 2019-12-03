#!/usr/bin/env zsh

source $DOTFILE_PATH/zsh/functions.sh

(
  THEME_DEST=~/Library/Developer/Xcode/UserData/FontAndColorThemes

  # install color themes
  mkdir -p $THEME_DEST

  for file in $DOTFILE_PATH/xcode/themes/*; do
    BASENAME=$(basename $file)
    DESTINATION_FILE="$THEME_DEST/$BASENAME"

    echo "* Installing $BASENAME..."
    (ln -s "$file" "$DESTINATION_FILE" > /dev/null 2>&1) && echo "    Linked: $DESTINATION_FILE" || (ln -sf "$file" "$DESTINATION_FILE" && echo "    Relinked: $DESTINATION_FILE")
  done
)
