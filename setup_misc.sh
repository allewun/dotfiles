#!/usr/bin/env zsh

(
  # fix ugly black background in BetterZipQL
  if [[ -e ~/Library/QuickLook/BetterZipQL.qlgenerator ]]; then
    MISC_PATH=$DOTFILE_PATH/misc/BetterZipQL
    QL_PATH=~/Library/QuickLook/BetterZipQL.qlgenerator/Contents/Resources

    cp -f $MISC_PATH/index.html $QL_PATH/
    cp -f $MISC_PATH/index_encrypted.html $QL_PATH/
    echo "Fixed BetterZipQL styles"
  fi

  # fix ugly/barely-visible xcode i-beam cursor
  XCODE_CURSOR_PATH=/Applications/Xcode.app/Contents/SharedFrameworks/DVTKit.framework/Resources
  sudo cp "$XCODE_CURSOR_PATH/DVTIbeamCursor.tiff" "$XCODE_CURSOR_PATH/DVTIbeamCursor-backup.tiff"
  sudo cp -f "$DOTFILE_PATH/misc/cursors/DVTIbeamCursor.tiff" "$XCODE_CURSOR_PATH/"
  echo "Fixed ugly/barely-visible xcode i-beam cursor"

  # install custom fonts
  cp "$DOTFILE_PATH/misc/fonts/Inconsolata-aw/Inconsolata-aw.otf" ~/Library/Fonts && echo "Installed Inconsolata-aw font"
  cp "$DOTFILE_PATH/misc/fonts/Inconsolata-aw/Inconsolata-aw-bold.otf" ~/Library/Fonts && echo "Installed Inconsolata-aw bold font"
  cp "$DOTFILE_PATH/misc/fonts/Inconsolata-aw/Inconsolata-aw-italic.otf" ~/Library/Fonts && echo "Installed Inconsolata-aw italic font"
)
