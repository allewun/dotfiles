#!/bin/zsh

#==========================
# Set up QuickLook plugins
#==========================

(
DOTFILE_PATH=~/dotfiles
QL_PATH=~/Library/QuickLook
DATE=($(date +%Y%m%d%H%M%S))

# backup existing QuickLook folder
if [[ -d $QL_PATH ]]; then
  mv $QL_PATH $QL_PATH-$DATE && echo "Backed-up old QuickLook directory to ~/Library/QuickLook-$DATE"
fi

gcp -rs $DOTFILE_PATH/QuickLook $QL_PATH

# reset QuickLook cache
qlmanage -r
)
