#!/usr/bin/env zsh

DATE=($(date +%Y%m%d%H%M%S))

# backup source history file if it exists already
if [[ -d $HOME/.vim ]]; then
  mv "$HOME/.vim" "$HOME/.vim-$DATE" && echo "Backed-up old .vim directory to $HOME/.vim-$DATE"
fi

gcp -rs "$DOTFILE_PATH/vim" "$HOME/.vim"
