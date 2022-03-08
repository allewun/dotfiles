#!/usr/bin/env zsh

# install custom fonts
if [[ "$OSTYPE" == "darwin"* ]]; then
    cp "$DOTFILE_PATH/misc/fonts/Inconsolata-aw/Inconsolata-aw.otf" ~/Library/Fonts && echo "✅ Installed Inconsolata-aw font"
    cp "$DOTFILE_PATH/misc/fonts/Inconsolata-aw/Inconsolata-aw-bold.otf" ~/Library/Fonts && echo "✅ Installed Inconsolata-aw bold font"
    cp "$DOTFILE_PATH/misc/fonts/Inconsolata-aw/Inconsolata-aw-italic.otf" ~/Library/Fonts && echo "✅ Installed Inconsolata-aw italic font"
fi

# install tip script
if [[ "$OSTYPE" == "darwin"* ]]; then
    TIP_PROVIDER=~/Library/Application\ Scripts/tanin.tip/provider.script
    cat << EOF > $TIP_PROVIDER
#!/usr/bin/env zsh
PATH=~/.rbenv/shims:\$PATH
~/dotfiles/scripts/tip-provider.rb \$@
EOF
    chmod +x $TIP_PROVIDER
    echo "✅ Added Tip script ($TIP_PROVIDER)"
fi

# install bat config
if hash bat &> /dev/null; then
  mkdir -p "$(dirname $(bat --config-file))"
  cp "$DOTFILE_PATH/.bat" "$(bat --config-file)"
  echo "✅ Copied .bat to $(bat --config-file)"
fi

echo "✅ Done."