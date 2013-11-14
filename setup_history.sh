#!/bin/zsh

#=========================
# Set up history symlink
#=========================

(
DROPBOX_HISTORY_PATH=~/Dropbox/history
HISTORY_FILE=$HOME/.zsh_history
DATE=($(date +%Y%m%d%H%M%S))

# setup .zsh_history symlink
echo "Name of file that ~/.zsh_history will be symlinked to: "
read HISTORY_FILE_NAME
echo

mkdir -p "$DROPBOX_HISTORY_PATH"

# if a history file (non-symlink) already exists, back it up
# otherwise create the backup and the history file
if [[ -f $HISTORY_FILE && ! -h $HISTORY_FILE ]]; then
  mv "$HISTORY_FILE" "$DROPBOX_HISTORY_PATH/.zsh_history-$DATE" && echo "Backed-up old history file to .zsh_history-$DATE"
elif [[ ! -f $HISTORY_FILE ]]; then
  touch "$DROPBOX_HISTORY_PATH/$HISTORY_FILE_NAME" "$HISTORY_FILE"
fi

# backup source history file if it exists already
if [[ -f $DROPBOX_HISTORY_PATH/$HISTORY_FILE_NAME ]]; then
  mv "$DROPBOX_HISTORY_PATH/$HISTORY_FILE_NAME" "$DROPBOX_HISTORY_PATH/$HISTORY_FILE_NAME-$DATE" && echo "Backed-up old source history file to $DROPBOX_HISTORY_PATH/$HISTORY_FILE_NAME-$DATE"
fi

# update the symlink
ln -sf "$DROPBOX_HISTORY_PATH/$HISTORY_FILE_NAME" "$HISTORY_FILE" && echo "Linked: .zsh_history -> $DROPBOX_HISTORY_PATH/$HISTORY_FILE_NAME"

echo "
*-----------------------------*
|  .zsh_history syncing done  |
*-----------------------------*\n"
)
