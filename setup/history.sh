#!/usr/bin/env zsh

#=========================
# Set up history symlink
#=========================

DROPBOX_HISTORY_PATH=~/Dropbox/history
HISTORY_FILE=$HOME/.zsh_history
DATE=($(date +%Y%m%d%H%M%S))

# setup .zsh_history symlink
echo "Name of backup file that will symlink to ~/.zsh_history: "
read HISTORY_FILE_NAME
echo

mkdir -p "$DROPBOX_HISTORY_PATH"

# create history file if it doesn't exist
if [[ ! -f $HISTORY_FILE ]]; then
  touch "$HISTORY_FILE"
fi

# update the symlink (Dropbox symlinks to ~/.zsh_history; Dropbox follows symlinks and saves the contents, rather than just the reference)
ln -sf "$HISTORY_FILE" "$DROPBOX_HISTORY_PATH/$HISTORY_FILE_NAME" && echo "Linked: $DROPBOX_HISTORY_PATH/$HISTORY_FILE_NAME -> ~/.zsh_history"

echo "
*-----------------------------*
|  .zsh_history syncing done  |
*-----------------------------*\n"
