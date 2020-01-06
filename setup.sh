#!/usr/bin/env zsh

autoload -U colors && colors

source "$DOTFILE_PATH/zsh/functions.sh"
source .zshrc

# Guard dotfiles repo
[[ "$(pwd)" == ~/dotfiles ]] || { echo "Ensure that this repo lives in ~/dotfiles" && exit 1; }

# Ensure homebrew installed
ensure_installed "brew" || { echo "Homebrew required." && exit 1; }

# Call subscripts
logsetup "dotfiles" && ./setup/dotfiles.sh   | indent 4
logsetup "macOS"    && ./setup/mac.sh        | indent 4
logsetup "vim"      && ./setup/vim.sh        | indent 4
logsetup "misc"     && ./setup/misc.sh       | indent 4
logsetup "Xcode"    && ./setup/xcode.sh      | indent 4
logsetup "Sublime"  && ./setup/sublime.sh    | indent 4
logsetup "Homebrew" && brew bundle --verbose | indent 4
