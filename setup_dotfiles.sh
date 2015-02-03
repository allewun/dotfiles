#!/usr/bin/env zsh

#==========================
# Set up dotfile symlinks
#==========================

(
DOTFILES_NEW=($(find $DOTFILE_PATH -not -name '.DS_Store' -name ".*" -type f -maxdepth 1 -exec basename {} \;))
DOTFILES_OLD_REG=($(comm -12 <(find $HOME         -not -name '.DS_Store' -name ".*" -type f -maxdepth 1 -exec basename {} \;) \
                             <(find $DOTFILE_PATH -not -name '.DS_Store' -name ".*" -type f -maxdepth 1 -exec basename {} \;)))
DATE=($(date +%Y%m%d%H%M%S))


# backup old dotfiles (regular files)
BACKUP_PATH="$HOME/dotfiles-$DATE"
if [[ -n $DOTFILES_OLD_REG ]]; then
  mkdir $BACKUP_PATH && echo "
*-----------------------------*
|  Old dotfiles backed-up to  |
|  ~/dotfiles-$DATE  |
*-----------------------------*\n"

  for i in $DOTFILES_OLD_REG; do
    mv $HOME/$i $BACKUP_PATH/$i
    echo "Backed-up old dotfile: $i"
  done
else
  echo "
*-----------------------------*
|     Nothing to back up      |
*-----------------------------*"
fi

echo

# symlink new dotfiles
for i in $DOTFILES_NEW; do
  f=$(basename $i)
  (ln -s "$DOTFILE_PATH/$f" "$HOME/$f" > /dev/null 2>&1) && echo "Linked: ~/$f" || (ln -sf "$DOTFILE_PATH/$f" "$HOME/$f" && echo "Relinked: $f")
done

echo "
*-----------------------------*
|  Done setting up dotfiles!  |
*-----------------------------*"
)
