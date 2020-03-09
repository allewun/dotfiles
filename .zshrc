#==============================================================================
# .zshrc (2013-2020)
# - Allen Wu
#==============================================================================

typeset -U PATH
export PATH=~/.rbenv/shims:/usr/local/bin:/usr/local:/sbin:/usr/sbin:/usr/local/sbin:$PATH:/usr/local/opt/coreutils/libexec/gnubin
export DOTFILE_PATH=~/dotfiles

#======================================
# Shell integrations
#======================================

# rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# autojump
[[ -s $(brew --prefix)/etc/autojump.sh ]] && . $(brew --prefix)/etc/autojump.sh


#======================================
# Private
#======================================

if [[ -d "${DOTFILE_PATH}-private/autocomplete" ]]; then
  fpath=($fpath "${DOTFILE_PATH}-private/autocomplete")
fi

if [[ -f "${DOTFILE_PATH}-private/.zshrc" ]]; then
  source "${DOTFILE_PATH}-private/.zshrc"
fi

#======================================
# Prompt
#======================================

setopt PROMPT_SUBST

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUPSTREAM=auto

# source prompt files
for p in $DOTFILE_PATH/zsh/prompts/*.sh;
  do source $p
done

# prompt: path, git status, rbenv status
NEWLINE=$'\n'
PROMPT='$NEWLINE%F{green}%~%f%F{cyan}$(__git_ps1 " [%s]")%f%F{red}$(__rbenv_ps1)%f$NEWLINE%F{white}$%f '

# directory in terminal tab title
function precmd() { echo -ne "\e]1;${PWD##*/}\a" }


#======================================
# Key bindings
#======================================

autoload -U history-search-end

zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end
bindkey "^[[3~" delete-char
bindkey "^[[1;9C" forward-word
bindkey "^[[1;9D" backward-word

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


#======================================
# zsh completion
#======================================

autoload -U compinit && compinit
setopt EXTENDED_GLOB
setopt GLOB_COMPLETE
setopt DOTGLOB

zstyle ':completion:*' completer _complete
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'

# menu selection
zstyle ':completion:*' menu select

compdef g=git


#======================================
# Aliases
#======================================

alias sudo="sudo " # allow sudo with aliases

# configs
alias zshrc=" v ~/.zshrc && src"
alias vimrc=" vim ~/.vimrc"
alias gitconfig=" v ~/.gitconfig"
alias hgrc=" v ~/.hgrc"
alias src=" source ~/.zshrc > /dev/null 2>&1 && echo Reloaded .zshrc"

# macOS applications
alias preview=" open -a Preview"
alias tower=" open -a Tower ."
alias ql=' qlmanage -p "$@" > /dev/null 2>&1'
alias f=" finder"
s() { subl "${1:-.}"; }

# directory shortcuts
alias desk=" cd ~/Desktop/"
alias deks=desk
alias dropbox="cd ~/Dropbox/"
alias sim="cd ~/Library/Application\ Support/iPhone\ Simulator/"
alias firefox="cd ~/Library/Application\ Support/Firefox/Profiles/*.default/"
alias sublime="cd ~/Library/Application\ Support/Sublime\ Text\ 3/"
alias pwdcp="pwd | tr -d '\n' | pbcopy"
js() { (j "$1"; s) }

# ls
alias ls=' ls -AFGh' # trailing slash for dirs and colors, human-readable filesizes

# cd
alias ..=' cd ..'
alias ...=' cd ../..'
alias ....=' cd ../../..'
alias .....=' cd ../../../..'

# mkdir
alias mkdir='mkdir -p'

# git
alias gti='git'
alias git--=' git checkout -- .'

# grep
alias grep='grep --color=auto'

# copy/paste
alias copy='pbcopy'
alias paste='pbpaste'
alias copypath='pwd | tr -d "\r\n" | pbcopy'
alias clearclip='echo -n "" | pbcopy'
alias clipclear='clearclip'

# hash
alias sha1='openssl sha1'
alias sha256='shasum -a 256'
alias sha512='shasum -a 512'
alias md5='openssl md5'

# networking
alias ip='dig +short myip.opendns.com @resolver1.opendns.com'
alias lip='ifconfig | grep "inet " | grep -v "127.0.0.1" | cut -d" " -f2'
alias geoip='curl -s "http://ip-api.com/json/$(ip)" | jsonc'
alias headers='curl -I'
alias speedtest='wget -O /dev/null http://184.82.225.2/bigtest.tgz'
alias airport="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"

# ruby/rails
alias rs='rails s'
alias rc='rails c'
alias irb='irb -r irb/completion'
alias be='bundle exec'

# vim
alias v='vim -c "'"'"'\""' # open to last position

# ocaml
alias ocaml="rlwrap ocaml"

# misc
alias tree=" tree -C | less"
alias json="python -m json.tool"
alias jsonc="json | pygmentize -f terminal256 -l javascript -O style=monokai"
alias curl="noglob curl" # prevent zsh from treating ? as wildcard in URLs
alias pubkey="pbcopy < ~/.ssh/id_rsa.pub && echo Copied public ssh key."
alias gcc49="gcc-4.9 -fdiagnostics-color=auto"
alias gcc42="gcc-4.2"
alias pythonserver="python -m SimpleHTTPServer"
alias pythonhttpsserver="python3 ~/dotfiles/scripts/https-server/pythonhttpsserver.py"
alias cats="pygmentize -g -f terminal256"
alias urldecode='python -c "import sys, urllib as ul; print ul.unquote_plus(sys.argv[1])"'
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1])"'
alias uuid='uuidgen | tee "$(tty)" | tr -d "\n" | pbcopy'
alias bepi='bundle exec pod install'
alias imagediff='git difftool development..$(git rev-parse --abbrev-ref HEAD) -- "*.png"'
alias imageoptim='/Applications/ImageOptim.app/Contents/MacOS/ImageOptim'

#======================================
# History
#======================================

HISTFILE=~/.zsh_history
HISTSIZE=100000000
SAVEHIST=100000000

setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY

# history ignores
for cmd (repo notify hist histsearch forget man manz xc md j dot); do 
  alias $cmd=" $cmd";
done

#======================================
# Environment Variables
#======================================

# common
export TERM="xterm-256color"
export EDITOR="vim"
export PAGER="less"

# color man pages
export LESS="-iRc"
export LESS_TERMCAP_mb=$'\E[0;36m'     # cyan
export LESS_TERMCAP_md=$'\E[0;36m'     # cyan
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[0;30;103m' # highlighted text
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

# xcode
export CURRENT_XCODE=$(xcode-select -p | grep -oE 'Xcode[^/]+')

# zsh
autoload -U colors && colors

#======================================
# Functions
#======================================
source $DOTFILE_PATH/zsh/functions.sh


#======================================
# Miscellaneous
#======================================

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
function lessc() {
  LESSOPEN="| pygmentize -f terminal256 -O style=monokai -g %s" less -R "$@";
}

#======================================
# Temporary stuff
#======================================

alias temp="cd ~/temp"

export NVM_DIR="/Users/allen/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

