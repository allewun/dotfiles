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

  # install custom fonts
  cp "$DOTFILE_PATH/misc/fonts/Inconsolata-aw/Inconsolata-aw.otf" ~/Library/Fonts && echo "Installed Inconsolata-aw font"
  cp "$DOTFILE_PATH/misc/fonts/Inconsolata-aw/Inconsolata-aw-bold.otf" ~/Library/Fonts && echo "Installed Inconsolata-aw bold font"
  cp "$DOTFILE_PATH/misc/fonts/Inconsolata-aw/Inconsolata-aw-italic.otf" ~/Library/Fonts && echo "Installed Inconsolata-aw italic font"
)
