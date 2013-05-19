#===========================================================================
# .bashrc
#  Allen Wu (5/19/2013)
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

source ~/.bash/git-completion.sh
source ~/.bash/git-prompt.sh
source ~/.bash/z.sh

function prompt_right() {
  local __dts="`date +"%a %d-%b-%Y %I:%M %p"`"

  echo -e "\033[0;35m${__dts}\033[0m"
}

function prompt_left() {
  local GREEN='\[\e[0;32m\]'
  local WHITE='\[\e[1;37m\]'
  local CYAN='\[\e[0;36m\]'
  local ENDCOLOR='\[\e[0m\]'

  local __dir="$GREEN\w$ENDCOLOR"
  local __git_branch='$(__git_ps1 " [%s]") '

  export GIT_PS1_SHOWDIRTYSTATE=1

  echo -e "$__dir$CYAN$__git_branch$ENDCOLOR"
}

function prompt() {
    # http://superuser.com/a/517110
    compensate=11
    export PS1=$(printf "%*s\r%s\n> " "$(($(tput cols)+${compensate}))" "$(prompt_right)" "$(prompt_left)")
}
prompt

shopt -s checkwinsize

export PAGER=less

# color man pages
export LESS="-iR"
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

export HISTSIZE=
export HISTFILESIZE=
export HISTCONTROL=ignoreboth
export HISTIGNORE=ls:pwd:bashrc
export PROMPT_COMMAND='history -a'
export HISTTIMEFORMAT='[%Y/%m/%d %T] '

shopt -s histappend

#===========================================================================
# Aliases
#===========================================================================

# Edit dotfiles/configs
alias bashrc="v ~/.bashrc && source ~/.bashrc"
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
alias desktop="cd ~/Desktop/"
alias iosimage="cd ~/scripts/iOSImageReport/iOSImageReport.rb"
alias ucla="cd ~/Dropbox/UCLA/\'12-\'13\ \(4th\ Year\)/13\ SPRING/"

alias cs131="cd ~/Dropbox/UCLA/\'12-\'13\ \(4th\ Year\)/13\ SPRING/CS\ 131/"
alias cs118="cd ~/Dropbox/UCLA/\'12-\'13\ \(4th\ Year\)/13\ SPRING/CS\ 118/"

# "Study" function
function study() {

  local __cs131Dir="/Users/allen/Dropbox/UCLA/'12-'13 (4th Year)/13 SPRING/CS 131/";
  local __cs131Site="https://courseweb.seas.ucla.edu/classView.php?term=13S&srs=187510200";

  local __cs118Dir="/Users/allen/Dropbox/UCLA/'12-'13 (4th Year)/13 SPRING/CS 118/"
  local __cs118Site="https://courseweb.seas.ucla.edu/classView.php?term=13S&srs=187350200";

  local __piazza="https://piazza.com/";

  case "$1" in
    "131")
      cs131;
      firefox $__cs131Site;
      firefox $__piazza;
      finder "$__cs131Dir";
      ;;
    "118")
      cs118;
      firefox $__cs118Site;
      firefox $__piazza;
      finder "$__cs118Dir";
      ;;
  esac
}

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

# vim
alias v='vim -c "'"'"'\""'

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
alias clearclip='echo -n "" | pbcopy'

# hash
alias sha1='openssl sha1'
alias md5='openssl md5'

# networking
alias ip='dig +short myip.opendns.com @resolver1.opendns.com'
alias headers='curl -I'
alias speedtest='wget -O /dev/null http://184.82.225.2/bigtest.tgz'

# ruby/rails
alias rs='rails s'
alias rc='rails c'

# Misc.
function histail() {
  if [ -z "$1" ]; then
    history | tail -10
  else
    history | tail -n "$1"
  fi
}

# append song to "to download" list
function song() {
  local __songfile="/Users/allen/Dropbox/dl.txt";

  if [ -z "$1" ]; then
    cat $__songfile
  else
    echo "$1" >> $__songfile
    echo "Added: \"$1\""
  fi
}

alias ocaml="rlwrap ocaml"

