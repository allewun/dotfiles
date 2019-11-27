#!/usr/bin/env zsh

autoload -U colors && colors

source $DOTFILE_PATH/zsh/functions.sh
source .zshrc

# Guard dotfiles repo
if [[ "$(pwd)" != ~/dotfiles ]]; then
  echo "Ensure that this repo lives in ~/dotfiles"
  exit 1
fi

# Call subscripts
logsetup "dotfiles" && ./setup/dotfiles.sh | indent 4
logsetup "macOS"    && ./setup/mac.sh      | indent 4
logsetup "vim"      && ./setup/vim.sh      | indent 4
logsetup "misc"     && ./setup/misc.sh     | indent 4
logsetup "Xcode"    && ./setup/xcode.sh    | indent 4
logsetup "Sublime"  && ./setup/sublime.sh  | indent 4

ensure_installed "brew" && (logsetup "Homebrew" && brew bundle --verbose) || echo "Homebrew not installed, skipping setup."
