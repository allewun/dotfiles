#==============================================================================
# .zshrc
# Allen Wu (Jan 2014)
#==============================================================================

typeset -U PATH
export PATH=~/.rbenv/shims:/usr/local/bin:/usr/local:$PATH
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

export DOTFILE_PATH=~/dotfiles


#==============================================================================
# Prompt
#==============================================================================

setopt PROMPT_SUBST

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUPSTREAM=auto

# source -prompt.sh files
for p in $DOTFILE_PATH/scripts/*-prompt.sh;
  do source $p
done

# left prompt: path and git status
NEWLINE=$'\n'
PROMPT='$NEWLINE%F{green}%~%f%F{cyan}$(__git_ps1 " [%s]")%f%F{red}$(__rbenv_ps1)%f%F{magenta}$(__heroku_ps1)%f$NEWLINE%F{white}>%f '

# right prompt: timestamp
function preexec() {
  DATE=$(date +"%a %d-%b-%Y %I:%M %p")
  RPROMPT="%F{magenta}$DATE%f"
}

# directory in terminal tab title
function precmd() { print -Pn "\e]2;%~\a" }


#==============================================================================
# Key bindings
#==============================================================================

autoload -U history-search-end

zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end
bindkey "^[[3~" delete-char

# ctrl-z toggle (http://serverfault.com/a/225821)
function ctrlz () {
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

# history ignores
for cmd (cd song repo dot notify histail forget);
  do alias $cmd=" $cmd";
done


#==============================================================================
# zsh completion
#==============================================================================

autoload -U compinit && compinit
setopt EXTENDED_GLOB
setopt GLOB_COMPLETE
setopt DOTGLOB

# case-insensitive (all), partial-word and then substring completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# menu selection
zstyle ':completion:*' menu select


#==============================================================================
# Aliases
#==============================================================================

# configs
alias zshrc=" v ~/.zshrc && src"
alias vimrc=" vim ~/.vimrc"
alias gitconfig=" v ~/.gitconfig"
alias osx=" v $DOTFILE_PATH/setup_osx.sh && source $DOTFILE_PATH/setup_osx.sh"
alias src=" source ~/.zshrc > /dev/null 2>&1 && echo Reloaded .zshrc"

# OS X applications
alias finder=" open -a Finder ."
alias firefox=" open -a Firefox"
alias chrome=" open -a Google\ Chrome"
alias preview=" open -a Preview"
alias xc=xcode
alias xcode=" open -a Xcode *.(xcworkspace|xcodeproj)"           # iOS 7
alias xcode4.6=" open -a Xcode4.6.app *.(xcworkspace|xcodeproj)" # iOS 6
alias xcode4.4=" open -a Xcode4.4.app *.(xcworkspace|xcodeproj)" # iOS 5
alias tower=" open -a Tower ."
alias mou=" open -a Mou"

# directory shortcuts
alias dotfiles="cd $DOTFILE_PATH"
alias desk="cd ~/Desktop/"
alias deks=desk
alias dropbox="cd ~/Dropbox/"
alias originate="cd ~/Dropbox/Originate/"
alias hist="cd ~/Dropbox/history/"

# ls
alias ls=' ls -AFG' # trailing slash for dirs and colors

# cd
alias ..='cd ..'
alias ....='cd ../..'
alias ......='cd ../../..'

# mkdir
alias mkdir='mkdir -p'

# git
alias gti='git'
alias github='hub'

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
alias irb='irb -r irb/completion'

# vim
alias v='vim -c "'"'"'\""' # open to last position

# ocaml
alias ocaml="rlwrap ocaml"

# misc
alias tree="tree -C | less"
alias json="python -m json.tool | pygmentize -f terminal256 -l javascript -O style=monokai"
alias curl="noglob curl" # prevent zsh from treating ? as wildcard in URLs
alias pubkey="pbcopy < ~/.ssh/id_rsa.pub && echo Copied public ssh key."
alias gcc49="gcc-4.9 -fdiagnostics-color=auto"
alias gcc48="gcc-4.8"
alias gcc46="gcc-4.6"
alias gcc42="gcc-4.2"


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

# tree colors
export TREE_COLORS='di=33;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:'

# grep colors
export GREP_COLOR='4;93' # yellow, underlined matches

# ack colors
export ACK_COLOR_FILENAME='underline cyan'
export ACK_COLOR_MATCH='underline yellow'
export ACK_COLOR_LINENO='cyan'


#==============================================================================
# Functions
#==============================================================================
source $DOTFILE_PATH/functions.sh


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

# less with syntax highlighting
function cless() {
  LESSOPEN="| pygmentize -f terminal256 -O style=monokai -g %s" less -R "$@";
}


#==============================================================================
# Temporary stuff
#==============================================================================

alias classscanner="cd ~/Desktop/ClassScanner"
alias hkn="cd ~/ucla-hkn"
alias work="cd ~/work"
alias temp="cd ~/temp"
