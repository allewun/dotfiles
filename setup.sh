#!/usr/bin/env zsh

autoload -U colors && colors

export DOTFILE_PATH=~/dotfiles # needed before first time (since .zshrc isn't installed yet)
source "$DOTFILE_PATH/zsh/functions.sh"
source .zshrc

# Guard dotfiles repo
[[ "$(pwd)" == ~/dotfiles ]] || { echo "Ensure that this repo lives in ~/dotfiles" && exit 1; }

# Ensure homebrew installed
if [[ "$OSTYPE" == "darwin"* ]]; then
    ensure_installed "brew" || { echo "Homebrew required." && exit 1; }
fi

# Call subscripts
logsetup "dotfiles" && ./setup/dotfiles.sh | indent 4
logsetup "macOS"    && ./setup/mac.sh      | indent 4
logsetup "vim"      && ./setup/vim.sh      | indent 4
logsetup "misc"     && ./setup/misc.sh     | indent 4
logsetup "Xcode"    && ./setup/xcode.sh    | indent 4
logsetup "Sublime"  && ./setup/sublime.sh  | indent 4

if [[ "$OSTYPE" == "darwin"* ]]; then
    logsetup "duti"     && duti ~/.duti
    logsetup "Homebrew" && brew bundle --file ~/dotfiles/Brewfile --verbose | indent 4
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
    logsetup "yum" && ./setup/yum.sh | indent 4
fi