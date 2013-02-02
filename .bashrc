#===========================================================================
# .bashrc
#  Allen Wu (2/2/2013)
#===========================================================================

# add ~/bin to $PATH
PATH=$PATH:$HOME/bin

# .inputrc stuff
export INPUTRC=~/.inputrc
bind -f ~/.inputrc

# RVM stuff
PATH=$PATH:$HOME/.rvm/bin
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

#===========================================================================
# Terminal / Prompt
#===========================================================================

# colored prompt with current git branch

source ~/.bash/.git-completion.sh
source ~/.bash/.git-prompt.sh

function prompt {
  local GREEN='\[\e[0;32m\]'
  local WHITE='\[\e[1;37m\]'
  local CYAN='\[\e[0;36m\]'
  local ENDCOLOR='\[\e[0m\]'

  local __dir="$GREEN\w$ENDCOLOR"
  local __git_branch='$(__git_ps1 " [%s]") '
  local __arrow="$WHITE>$ENDCOLOR"

  export GIT_PS1_SHOWDIRTYSTATE=1
  export PS1="$__dir$CYAN$__git_branch$ENDCOLOR$__arrow "
}

prompt

shopt -s checkwinsize

# color man pages
export LESS_TERMCAP_mb=$'\E[0;36m'     # cyan
export LESS_TERMCAP_md=$'\E[0;36m'     # cyan
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[0;30;102m' # highlighted text
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[0;33m'     # yellow

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
alias dotfiles="cd ~/Dropbox/dotfiles/"
alias iosimage="cd ~/scripts/iOSImageReport/iOSImageReport.rb"
alias ucla="cd ~/Dropbox/UCLA/\'12-\'13\ \(4th\ Year\)/13\ WINTER/"

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

# mkdir
alias mkdir='mkdir -p'

# git
alias gti='git'

# grep
alias grep='grep --color=auto'
export GREP_COLOR='4;93' # yellow, underlined matches

# ack
export ACK_COLOR_FILENAME='underline cyan'
export ACK_COLOR_MATCH='underline yellow'
export ACK_COLOR_LINENO='cyan'

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
alias speedtest="wget -O /dev/null http://184.82.225.2/bigtest.tgz"

# ruby/rails
alias rs='rails s'
alias rc='rails c'

