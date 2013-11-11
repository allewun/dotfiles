#!/bin/zsh

#==============================================================================
# Set up dotfile symlinks
#==============================================================================

DOTFILE_PATH=~/dotfiles
DOTFILES_NEW=($(echo $DOTFILE_PATH/.*(^/)))
DOTFILES_OLD_REG=($(comm -12 <(find $DOTFILE_PATH -name ".*" -type f -maxdepth 1 -exec basename {} \;) \
                             <(find $HOME         -name ".*" -type f -maxdepth 1 -exec basename {} \;)))
DOTFILES_OLD_SYM=($(comm -12 <(find $DOTFILE_PATH -name ".*" -type f -maxdepth 1 -exec basename {} \;) \
                             <(find $HOME         -name ".*" -type l -maxdepth 1 -exec basename {} \;)))
DROPBOX_HISTORY_PATH=~/Dropbox/history
HISTORY_FILE=$HOME/.zsh_history
DATE=($(date +%Y%m%d%H%M%S))


# backup old dotfiles (regular files)
BACKUP_PATH="$HOME/dotfiles-$DATE"
if [[ -n $DOTFILES_OLD_REG ]]; then
  mkdir $BACKUP_PATH && echo -e "
*-----------------------------*
|  Old dotfiles backed-up to  |
|  ~/dotfiles-$DATE  |
*-----------------------------*\n"

  for i in $DOTFILES_OLD_REG; do
    mv $HOME/$i $BACKUP_PATH/$i
    echo "Backed-up old dotfile: $i"
  done

  echo -e
else
  echo -e "
*-----------------------------*
|     Nothing to back up      |
*-----------------------------*\n"
fi

# delete old symlinked dotfiles
for i in $DOTFILES_OLD_SYM; do
  rm $HOME/$i && echo "Deleted old symlink: $i"
done

echo -e

# symlink new dotfiles
for i in $DOTFILES_NEW; do
  f=`basename $i`
  ln -s "$DOTFILE_PATH/$f" "$HOME/$f" && echo "Linked: $f"
done

echo -e

# setup .zsh_history symlink
echo "Name of file that ~/.zsh_history will be symlinked to: "
read HISTORY_FILE_NAME
echo -e

mkdir -p "$DROPBOX_HISTORY_PATH"

# if a history file (non-symlink) already exists, back it up
# otherwise create the backup and the history file
if [[ -f $HISTORY_FILE && ! -h $HISTORY_FILE ]]; then
  mv "$HISTORY_FILE" "$DROPBOX_HISTORY_PATH/.zsh_history-$DATE" && echo -e "Backed-up old history file to .zsh_history-$DATE"
elif [[ ! -f $HISTORY_FILE ]]; then
  touch "$DROPBOX_HISTORY_PATH/$HISTORY_FILE_NAME" "$HISTORY_FILE"
fi

# update the symlink
ln -sf "$DROPBOX_HISTORY_PATH/$HISTORY_FILE_NAME" "$HISTORY_FILE" && echo -e "Linked: .zsh_history -> $DROPBOX_HISTORY_PATH/$HISTORY_FILE_NAME"


  echo -e "
*-----------------------------*
| Setup .zsh_history syncing  |
*-----------------------------*\n"

echo -e "
*-----------------------------*
|  Done setting up dotfiles!  |
*-----------------------------*\n"
