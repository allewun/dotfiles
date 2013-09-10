#==============================================================================
# .zshrc
# Allen Wu (9/9/2013)
#==============================================================================

# Add RVM to PATH for scripting
PATH=$PATH:$HOME/.rvm/bin
# Add ~/bin to path
PATH=$PATH:$HOME/bin

autoload -U compinit && compinit
## case-insensitive (all),partial-word and then substring completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

setopt AUTOPUSHD
setopt PUSHDIGNOREDUPS

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

bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

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

#==============================================================================
# Aliases
#==============================================================================

alias zshrc="v ~/.zshrc && source ~/.zshrc"
alias vimrc="vim ~/.vimrc"
alias gitconfig="vim ~/.gitconfig"

alias finder="open -a Finder ."
alias firefox="open -a Firefox"
alias chrome="open -a Google\ Chrome"
alias preview="open -a Preview"
alias xcode="open -a Xcode"
alias tower="open -a Tower"

alias dotfiles="cd ~/Dropbox/dotfiles/"
alias desktop="cd ~/Desktop/"
alias originate="cd ~/Dropbox/Originate/"


export LSCOLORS=dxfxcxdxbxegedabagacad
alias ls=' ls -AFG' # trailing slash for dirs and colors

# automatically 'ls' after 'cd'
function chpwd() {
  emulate -L zsh
  ls
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

# Misc.
function histail() {
  if [ -z "$1" ]; then
    history | tail -10
  else
    history | tail -n "$1"
  fi
}

# color man pages
export LESS="-iR"
export LESS_TERMCAP_mb=$'\E[0;36m'     # cyan
export LESS_TERMCAP_md=$'\E[0;36m'     # cyan
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[0;30;102m' # highlighted text
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[0;33m'     # yellow




