#!/bin/zsh

brew update
brew upgrade

# brew-cask
brew tap caskroom/cask
brew install brew-cask
brew upgrade brew-cask
brew cask install xquartz
brew cask install easysimbl
brew cask install powerkey

brew install zsh
brew install ack
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
brew install gcc48
brew install gcc49
