#!/bin/bash

#==============================================================================
# Set up dotfile symlinks
#==============================================================================

DOTFILE_PATH=~/Dropbox/dotfiles
DOTFILES=".zshrc
.zsh_history
.bashrc
.bash_history
.gitconfig
.gitignore
.vimrc
.tmux.conf
.osx"

echo -e "
*-----------------------------*
|    Setting up dotfiles...   |
*-----------------------------*\n"

# backup old dotfiles
cd $HOME
BACKUP_PATH="$HOME/dotfiles-"`date +%Y%m%d%H%M`
mkdir $BACKUP_PATH
mv $DOTFILES $BACKUP_PATH
mv scripts $BACKUP_PATH

echo -e "
*-----------------------------*
|  Backed-up old dotfiles to  |
|  ~/dotfiles-`date +%Y%m%d%H%M%S`  |
*-----------------------------*\n"

# symlink dotfiles
for i in $DOTFILES; do
  ln -s "$DOTFILE_PATH/$i" "$HOME/$i"
done

echo -e "
*-----------------------------*
|     Dotfiles symlinked!     |
*-----------------------------*\n"

# symlink misc scripts
mkdir ~/scripts
for i in $DOTFILE_PATH/scripts/*; do
  ln -s $i "$HOME/scripts/"`basename $i`
done

echo -e "
*-----------------------------*
|      Scripts symlinked!     |
*-----------------------------*\n"


echo -e "
*-----------------------------*
|  Done setting up dotfiles!  |
*-----------------------------*\n"
