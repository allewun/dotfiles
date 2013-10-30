#!/bin/bash

#==============================================================================
# Set up dotfile symlinks
#==============================================================================

echo -e "\nSettings up dotfiles...\n-----------------------\n"

# zsh
ln -s ~/Dropbox/dotfiles/.zshrc ~/.zshrc || exit
ln -s ~/Dropbox/dotfiles/.zsh_history ~/.zsh_history || exit
echo ".zshrc, .zsh_history linked!"

# source .zshrc
source ~/.zshrc || exit
echo ".zshrc sourced"

# bash (for historical reasons)
ln -s ~/Dropbox/dotfiles/.bashrc ~/.bashrc || exit
ln -s ~/Dropbox/dotfiles/.bash_history ~/.bash_history || exit
echo ".bashrc, .bash_history linked!"

# git
ln -s ~/Dropbox/dotfiles/.gitconfig ~/.gitconfig || exit
ln -s ~/Dropbox/dotfiles/.gitignore ~/.gitignore || exit
echo ".gitconfig, .gitignore linked!"

# vim
ln -s ~/Dropbox/dotfiles/.vimrc ~/.vimrc || exit
echo ".vimrc linked!"

# tmux
ln -s ~/Dropbox/dotfiles/.tmux.conf ~/.tmux.conf || exit
echo ".tmux.conf linked!"

# misc. files
mkdir ~/scripts
for script in ~/Dropbox/dotfiles/scripts/* do
  ln -s $script "~/scripts/`basename $script`" || exit
done
echo "/scripts linked!"

# OS X
ln -s ~/Dropbox/dotfiles/.osx ~/.osx || exit
echo ".osx linked!"

source ~/.osx || exit
echo "OS X settings applied!"

echo -e "\n-----------------------\nDone!"
