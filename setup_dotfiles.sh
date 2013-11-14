#!/bin/zsh

#==========================
# Set up dotfile symlinks
#==========================

DOTFILE_PATH=~/dotfiles
DOTFILES_NEW=($(echo $DOTFILE_PATH/.*(^/)))
DOTFILES_OLD_REG=($(comm -12 <(find $DOTFILE_PATH -name ".*" -type f -maxdepth 1 -exec basename {} \;) \
                             <(find $HOME         -name ".*" -type f -maxdepth 1 -exec basename {} \;)))
DOTFILES_OLD_SYM=($(comm -12 <(find $DOTFILE_PATH -name ".*" -type f -maxdepth 1 -exec basename {} \;) \
                             <(find $HOME         -name ".*" -type l -maxdepth 1 -exec basename {} \;)))
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

echo -e "
*-----------------------------*
|  Done setting up dotfiles!  |
*-----------------------------*\n"
