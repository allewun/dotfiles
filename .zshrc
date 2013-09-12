#==============================================================================
# .zshrc
# Allen Wu (9/12/2013)
#==============================================================================

export PATH=$PATH:/usr/local/bin:$HOME/bin


#==============================================================================
# Prompt
#==============================================================================

setopt PROMPT_SUBST
source ~/.bash/git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1

# left prompt: path and git status
NEWLINE=$'\n'
PROMPT='$NEWLINE%F{green}%~%f%F{cyan}$(__git_ps1 " [%s]")%f$NEWLINE%F{white}>%f '

# right prompt: timestamp
preexec() {
  DATE=$(date +"%a %d-%b-%Y %I:%M %p")
  RPROMPT="%F{magenta}$DATE%f"
}


#==============================================================================
# Key bindings
#==============================================================================

autoload -U history-search-end

zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end

# ctrl-z toggle (http://serverfault.com/a/225821)
ctrlz () {
  if [[ $#BUFFER -eq 0 ]]; then
    fg
    zle redisplay
  else
    zle push-input
  fi
}
zle -N ctrlz
bindkey '^Z' ctrlz


#==============================================================================
# History
#==============================================================================

HISTFILE=~/.zsh_history
HISTSIZE=100000000
SAVEHIST=100000000

setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY


#==============================================================================
# zsh completion
#==============================================================================

autoload -U compinit && compinit

# case-insensitive (all), partial-word and then substring completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# menu selection
zstyle ':completion:*' menu select

#==============================================================================
# Aliases
#==============================================================================

# configs
alias zshrc="v ~/.zshrc && source ~/.zshrc"
alias vimrc="vim ~/.vimrc"
alias gitconfig="vim ~/.gitconfig"

# OS X applications
alias finder="open -a Finder ."
alias firefox="open -a Firefox"
alias chrome="open -a Google\ Chrome"
alias preview="open -a Preview"
alias xcode="open -a Xcode"
alias tower="open -a Tower"

# directory shortcuts
alias dotfiles="cd ~/Dropbox/dotfiles/"
alias desktop="cd ~/Desktop/"
alias dropbox="cd ~/Dropbox/"
alias originate="cd ~/Dropbox/Originate/"

alias ls=' ls -AFG' # trailing slash for dirs and colors

# mkdir
alias mkdir='mkdir -p'

# git
alias gti='git'

# grep
alias grep='grep --color=auto'

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

# vim
alias v='vim -c "'"'"'\""' # open to last position

# ocaml
alias ocaml="rlwrap ocaml"

#==============================================================================
# Environment Variables
#==============================================================================

# color man pages
export LESS="-iR"
export LESS_TERMCAP_mb=$'\E[0;36m'     # cyan
export LESS_TERMCAP_md=$'\E[0;36m'     # cyan
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[0;30;102m' # highlighted text
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[0;33m'     # yellow

# ls colors
export LSCOLORS=dxfxcxdxbxegedabagacad

# grep colors
export GREP_COLOR='4;93' # yellow, underlined matches

# ack colors
export ACK_COLOR_FILENAME='underline cyan'
export ACK_COLOR_MATCH='underline yellow'
export ACK_COLOR_LINENO='cyan'


#==============================================================================
# Functions
#==============================================================================

function histail() {
  if [ -z "$1" ]; then
    history 1 | tail -10
  else
    history 1 | tail -n "$1"
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


#==============================================================================
# Miscellaneous
#==============================================================================

setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

# speed up git completion
__git_files () {
  _wanted files expl 'local files' _files
}

# automatically 'ls' after 'cd'
function chpwd() {
  emulate -L zsh
  ls
}


#==============================================================================
# Temporary stuff
#==============================================================================

