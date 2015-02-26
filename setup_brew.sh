#!/usr/bin/env zsh

brew cleanup
brew update
brew upgrade

# brew-cask
brew install caskroom/cask/brew-cask
brew cask cleanup
brew upgrade brew-cask
brew cask install xquartz
brew cask install easysimbl
brew cask install powerkey

brew install zsh
brew install ag
brew install wget
brew install coreutils
brew install tree
brew install imagemagick
brew install tmux
brew install watch
brew install tig
brew install git-extras
brew install terminal-notifier
brew install ffmpeg
brew install mysql
brew install p7zip
brew install rbenv ruby-build rbenv-gem-rehash rbenv-gemset
brew install heroku
brew install ctags
brew install gifsicle
brew install pv
brew install python3
brew install reattach-to-user-namespace
brew install htop
brew install mongoose
brew install git
brew install autojump
brew install git-cal
brew install npm
brew install hub

# quicklook
brew cask install qlcolorcode
brew cask install qlstephen
brew cask install qlmarkdown
brew cask install quicklook-json
brew cask install suspicious-package
brew cask install ipaql
brew cask install betterzipql

brew tap homebrew/versions
brew install apple-gcc42
brew install gcc49

brew tap originate/gittown
brew install git-town

