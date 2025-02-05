#==============================================================================
# .zshrc (2013-2024)
# - Allen Wu
#==============================================================================

typeset -U PATH
export DOTFILE_PATH=~/dotfiles
export PATH=~/Library/Python/3.9/bin:~/homebrew/bin:~/.rbenv/shims:/usr/local/bin:/usr/local:/sbin:/usr/sbin:/usr/local/sbin:$PATH:/usr/local/opt/coreutils/libexec/gnubin:$DOTFILE_PATH/scripts:/usr/local/opt/fzf/bin:/Applications/Sublime\ Text.app/Contents/SharedSupport/bin

#======================================
# Shell integrations
#======================================

# rbenv
if hash rbenv &> /dev/null; then
  eval "$(rbenv init -)";
fi

# autojump
if hash brew &>/dev/null; then
  [[ -s $(brew --prefix)/etc/autojump.sh ]] && . $(brew --prefix)/etc/autojump.sh
fi

# iterm
source "$DOTFILE_PATH/zsh/iterm2_shell_integration.zsh"

# fzf
if hash fzf &> /dev/null; then
  [[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.zsh" 2> /dev/null
fi

# broot
if hash broot &>/dev/null; then
  if [[ -f ~/Library/Preferences/org.dystroy.broot/launcher/bash/br ]]; then
    source ~/Library/Preferences/org.dystroy.broot/launcher/bash/br
  elif [[ -f  ~/.config/broot/launcher/bash/br ]]; then
    source ~/.config/broot/launcher/bash/br
  fi
fi

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

# prompt
__aw_prompt() {
  local NEWLINE=$'\n'
  local GIT_PROMPT='%F{cyan}$(__git_ps1 " [%s]")%f' # git in cyan
  local HG_PROMPT='%F{yellow}$(_hg_prompt " [%s]")%f' # hg in yellow
  local RBENV_PROMPT='%F{red}$(__rbenv_ps1)%f' # rbenv in red
  local REL_PATH='%F{green}%~%f' # relative path in green
  local HOSTNAME=$([[ -n "$SSH_CONNECTION" ]] && echo '%m' || echo '')
  local TEXT_ENTRY="%F{white}${HOSTNAME}$%f " # right before the cursor
  echo "${NEWLINE}%{$(iterm2_prompt_mark)%}${REL_PATH}${GIT_PROMPT}${HG_PROMPT}${RBENV_PROMPT}${NEWLINE}${TEXT_ENTRY}"
} 
export PS1=$(__aw_prompt)

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
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word

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

setopt EXTENDED_GLOB
setopt GLOB_COMPLETE
setopt DOTGLOB

autoload -Uz compinit && compinit

# mostly from: https://github.com/scriptingosx/dotfiles/blob/master/zshrc

# case insensitive autocomplete
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

# show descriptions when autocompleting
zstyle ':completion:*' auto-description 'specify: %d'

# partial completion suggestions
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' expand prefix suffix

# list with colors
zstyle ':completion:*' list-colors ''x

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
alias src=" exec zsh -l && echo Reloaded .zshrc" # https://news.ycombinator.com/item?id=23309427

# macOS applications
alias preview=" open -a Preview"
alias tower=" open -a Tower ."
alias ql=' qlmanage -p "$@" > /dev/null 2>&1'
alias f=" finder"

# sublime
s() {
  if hash subl &>/dev/null; then
    # if no positional args ($@), open '.'
    subl "${@:-.}";
  elif hash rmate &>/dev/null; then
    rmate -n "${@:-.}";
  else
    echo "Couldn't open files with sublime"
  fi
}

ss() {
  # s (new window)
  if hash subl &>/dev/null; then
    # if no positional args ($@), open '.'
    subl -n "${@:-.}";
  else
    echo "Couldn't open files with sublime"
  fi
}

# ffmpeg 

ffmpeg265() {
  if [[ -z "$1" ]]; then echo "Usage: ffmpeg265 input [output]"; return; fi

  local destination
  # foo.xyz -> foo.xyz-x265.mp4
  if [[ -z "$2" ]]; then destination="${1}-x265.mp4"; fi

  ffmpeg -i "$1" -c:v libx265 -pix_fmt yuv420p -preset fast -crf 28 -tag:v hvc1 "$destination"
}

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
# trailing slash for dirs, colors, human-readable filesizes
if [[ "$OSTYPE" == "darwin"* ]]; then
  alias ls=' ls -AFGh'
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
  alias ls=' ls -AFh --color=always'
fi

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
alias fixcalendar='launchctl stop com.apple.CalendarAgent'
# dot() { cd $DOTFILE_PATH }
dots() { s "$DOTFILE_PATH" "${DOTFILE_PATH}-private"}

#======================================
# History
#======================================

HISTFILE=~/.zsh_history
HISTSIZE=100000000
SAVEHIST=100000000
HISTORY_IGNORE="(ls|cd|cd ..|pwd|hist|forget|man|md|s|f|dot|dots|tower)"

setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY

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

# bat
export BAT_PAGER="less -RF"

# ls colors
export LSCOLORS=dxfxcxdxbxegedabagacad # bsd
export LS_COLORS="di=33:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43" # linux

# tree colors
export TREE_COLORS='di=33;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:'

# grep colors
export GREP_COLOR='04;93' # yellow, underlined matches

# ack colors
export ACK_COLOR_FILENAME='underline cyan'
export ACK_COLOR_MATCH='underline yellow'
export ACK_COLOR_LINENO='cyan'

# homebrew
export HOMEBREW_NO_AUTO_UPDATE=1

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

# bat for compressed files
# https://github.com/sharkdp/bat/issues/237#issuecomment-566495835
function zbat() {
  if [[ -z "$1" ]]; then
    echo "Usage: zbat container.zip file.json"
  fi
  [[ "$2" =~ '([^\.]+)$' ]] && EXTENSION=$MATCH
  unzip -p "$1" "$2" | bat -l "$EXTENSION"
}


#======================================
# Temporary stuff
#======================================

alias temp="cd ~/temp"
