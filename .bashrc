#===========================================================================
# .bashrc
#  Allen Wu (1/28/2013)
#===========================================================================

export INPUTRC=~/.inputrc

# RVM stuff
PATH=$PATH:$HOME/.rvm/bin
[[ -s "/Users/allen/.rvm/scripts/rvm" ]] && source "/Users/allen/.rvm/scripts/rvm"

#===========================================================================
# Terminal / Prompt
#===========================================================================

GREEN='\[\e[0;32m\]'
WHITE='\[\e[1;37m\]'
ENDCOLOR='\[\e[0m\]'
export PS1="$GREEN\w$ENDCOLOR $WHITE>$ENDCOLOR "

shopt -s checkwinsize

# color man pages
export LESS_TERMCAP_mb=$'\E[01;36m'
export LESS_TERMCAP_md=$'\E[01;36m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;33m'

#===========================================================================
# History
#===========================================================================

export HISTSIZE=100000
export HISTCONTROL=ignoreboth
export PROMPT_COMMAND='history -a'
export HISTTIMEFORMAT='[%Y/%m/%d %T] '

shopt -s histappend

#===========================================================================
# Aliases
#===========================================================================

# Edit dotfiles/configs
alias bashrc="vim ~/.bashrc && source ~/.bashrc"
alias vimrc="vim ~/.vimrc"
alias gitconfig="vim ~/.gitconfig"

# Open OS X applications
alias finder="open -a Finder ."
alias firefox="open -a Firefox"
alias chrome="open -a Google\ Chrome"
alias preview="open -a Preview"
alias xcode="open -a Xcode"

# Directory shortcuts
alias iosimage="~/scripts/iOSImageReport/iOSImageReport.rb"
alias ucla="~/Dropbox/UCLA/\'12-\'13\ \(4th\ Year\)/13\ WINTER/"

alias ee115c="cd ~/Dropbox/UCLA/\'12-\'13\ \(4th\ Year\)/13\ WINTER/EE\ 115C/"
alias stats="cd ~/Dropbox/UCLA/\'12-\'13\ \(4th\ Year\)/13\ WINTER/Stats\ 105/"
alias cadence="ssh -c arcfour,blowfish-cbc -XC wua@eeapps.seas.ucla.edu"

#================
# Shell commands
#================

# ls
export LSCOLORS=dxfxcxdxbxegedabagacad
alias ls=' ls -AFG' # trailing slash for dirs, and colors

# cd
alias cd..='cd ..'
alias cdu='cd ..'
alias cd2='cd ../..'
alias cd3='cd ../../..'
alias cd4='cd ../../../..'
alias cd-='cd -'
alias cd~='cd ~'

function cd() {
  builtin cd "$*" && ls
}

# git
alias gti='git'

# grep
alias grep='grep --color=auto'

# copy/paste
alias copy='pbcopy'
alias paste='pbpaste'
alias copypath='pwd | tr -d "\r\n" | pbcopy'
alias cdpaste='cd `paste`'
alias clearclip='echo -n "" | pbcopy'

# hash
alias sha1='openssl sha1'
alias md5='openssl md5'

# networking
alias ip="curl http://ident.me/; echo"
alias headers="curl -I"
