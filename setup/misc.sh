#!/usr/bin/env zsh

# install custom fonts
if [[ "$OSTYPE" == "darwin"* ]]; then
    cp "$DOTFILE_PATH/misc/fonts/Inconsolata-aw/Inconsolata-aw.otf" ~/Library/Fonts && echo "Installed Inconsolata-aw font"
    cp "$DOTFILE_PATH/misc/fonts/Inconsolata-aw/Inconsolata-aw-bold.otf" ~/Library/Fonts && echo "Installed Inconsolata-aw bold font"
    cp "$DOTFILE_PATH/misc/fonts/Inconsolata-aw/Inconsolata-aw-italic.otf" ~/Library/Fonts && echo "Installed Inconsolata-aw italic font"
fi

# install tip scripts
if [[ "$OSTYPE" == "darwin"* ]]; then
    cp "$DOTFILE_PATH/scripts/tip-provider.rb" ~/Library/Application\ Scripts/tanin.tip/provider.script && echo "Synced Tip script"
fi

echo "✅ Done."