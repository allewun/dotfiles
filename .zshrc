#==============================================================================
# .zshrc
# Allen Wu (11/10/2013)
#==============================================================================

export PATH=/usr/local/bin:/usr/local:$PATH


#==============================================================================
# Prompt
#==============================================================================

setopt PROMPT_SUBST
source ~/dotfiles/scripts/git-prompt.sh
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
bindkey "^[[3~" delete-char

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
setopt EXTENDED_GLOB
setopt GLOB_COMPLETE

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
alias gitconfig="v ~/.gitconfig"
alias osx="v ~/.osx && source ~/.osx"

# OS X applications
alias finder=" open -a Finder ."
alias firefox=" open -a Firefox"
alias chrome=" open -a Google\ Chrome"
alias preview=" open -a Preview"
alias xc=xcode
alias xcode=" open -a Xcode *.(xcworkspace|xcodeproj)"           # iOS 7
alias xcode4.6=" open -a Xcode4.6.app *.(xcworkspace|xcodeproj)" # iOS 6
alias xcode4.4=" open -a Xcode4.4.app *.(xcworkspace|xcodeproj)" # iOS 5
alias tower=" open -a Tower"

# directory shortcuts
alias dotfiles="cd ~/dotfiles/"
alias desk="cd ~/Desktop/"
alias dropbox="cd ~/Dropbox/"
alias originate="cd ~/Dropbox/Originate/"

# ls
alias ls=' ls -AFG' # trailing slash for dirs and colors

# cd
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

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

# vim
alias v='vim -c "'"'"'\""' # open to last position

# ocaml
alias ocaml="rlwrap ocaml"

# misc
alias tree="tree | less"
alias json="python -m json.tool | pygmentize -f terminal256 -l javascript -O style=monokai"
alias curl="noglob curl" # prevent zsh from treating ? as wildcard in URLs

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

# open a repository online
# if no arguments provided, guess the hosting service
#
# Usage:
#   repo(domain, branchPath)
#     - domain     : domain of service
#     - branchPath : URL path to reach branch
#
# (modified from: http://askubuntu.com/a/243485)

function repo {
  domain=$1
  branchPath=$2

  # check if valid git repo
  if git rev-parse --git-dir > /dev/null 2>&1; then

    # guess git hosting service
    if [[ -z $domain && -z $branchPath ]]; then
      remotes=$(git remote -v)

      if [[ $remotes =~ "github" ]]; then
        domain="github.com"
        branchPath="/tree/"
      elif [[ $remotes =~ "bitbucket" ]]; then
        domain="bitbucket.org"
        branchPath="/commits/branch/"
      else
        echo "Unable to determine git hosting service."
        return
      fi
    fi

    remotes=$(git remote -v | awk -F'git@'$domain: '{print $2}')
    if [ -z $remotes ]; then
      remotes=$(git remote -v | awk -F'https://'$domain/ '{print $2}')
    fi

    remoteURL=$(echo $remotes | cut -d" " -f1 | head -n 1 | sed 's/.git//')
    branch=$(git rev-parse --abbrev-ref HEAD)

    if [[ -n $branch && -n $remoteURL && $branch != "master" ]]; then
      branch="${branchPath}${branch}"
    else
      branch=""
    fi

    open "https://${domain}/${remoteURL}${branch}"
  else
    echo "Not a repository."

    if [[ -n $domain ]]; then
      open "https://${domain}/"
    fi
  fi
}

# open repository on github
function hub {
  repo "github.com" "/tree/"
}

# open repository on bitbucket
function bit {
  repo "bitbucket.org" "/commits/branch/"
}

# git blame colors
function blame {
  red=$(echo '\033[31m')
  green=$(echo '\033[32m')
  cyan=$(echo '\033[36m')
  yellow=$(echo '\033[33m')
  magenta=$(echo '\033[35m')
  none=$(echo '\033[0m')

  git blame $1 | sed -E "s/^([0-9a-z^]+)([^(]*)( +)\(([A-Za-z ]+)( +)([0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2} [-+][0-9]{4})( +)([0-9]+)\)(.*)$/$red\1$none$green\2$none\3($cyan\4$none\5$yellow\6$none\7$magenta\8$none)\9/" | less -R
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

