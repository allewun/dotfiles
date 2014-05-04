#!/bin/zsh

autoload -U colors && colors

echo "$fg[cyan]Sourcing .zshrc...$reset_color"      && source .zshrc
echo "$fg[cyan]Setting up brew...$reset_color"      && ./setup_brew.sh
echo "$fg[cyan]Setting up dotfiles...$reset_color"  && ./setup_dotfiles.sh
echo "$fg[cyan]Setting up vim...$reset_color"       && ./setup_vim.sh
echo "$fg[cyan]Setting up osx...$reset_color"       && ./setup_osx.sh
echo "$fg[cyan]Setting up history...$reset_color"   && ./setup_history.sh
