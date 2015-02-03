#!/usr/bin/env zsh

echo "Ensure that .zshrc has been sourced first. Press any key to continue."
read

autoload -U colors && colors

echo "$fg[cyan]Setting up brew...$reset_color"      && ./setup_brew.sh
echo "$fg[cyan]Setting up dotfiles...$reset_color"  && ./setup_dotfiles.sh
echo "$fg[cyan]Setting up vim...$reset_color"       && ./setup_vim.sh
echo "$fg[cyan]Setting up osx...$reset_color"       && ./setup_osx.sh
echo "$fg[cyan]Setting up history...$reset_color"   && ./setup_history.sh
echo "$fg[cyan]Setting up misc...$reset_color"      && ./setup_misc.sh
echo "$fg[cyan]Setting up iTerm...$reset_color"     && ./setup_iterm.sh
