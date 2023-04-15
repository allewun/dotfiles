#!/usr/bin/env zsh

source "$DOTFILE_PATH/zsh/utility.sh"

# show formatted history in pager
function hist() {
  local yellow=$'\033[33m'
  local magenta=$'\033[35m'
  local none=$'\033[0m'

  echo "${magenta}$(wc -l "$HISTFILE" | sed -e 's/^[ ]*//')${none}"
  \history -nt '%F %T' 1 | sed -E "s/^([0-9: -]{19})(.*)$/${yellow}[\1]${none}\2/g" | less +G
}


# search history
function histsearch() {
  grep -i "$1" "$HISTFILE"
}

function finder {
  local directory=$1

  if [[ -z "$directory" ]]; then
    directory="$(pwd)"
  fi

  open -a Finder "$directory"
}

function cheat {
  curl "cheat.sh/$1"
}


# open a repository online
# if no arguments provided, guess the hosting service
# bonus: if branch is gh-pages, open the github.io page
#
# Usage:
#   repo(domain, branchPath)
#     - domain     : domain of service
#     - branchPath : URL path to reach branch
#
# (modified from: http://askubuntu.com/a/243485)
function repo() {
  local domain=$1
  local branchPath=$2

  # check if valid git repo
  if git rev-parse --git-dir > /dev/null 2>&1; then

    # guess git hosting service
    if [[ -z "$domain" && -z "$branchPath" ]]; then
      remotes=$(git remote -v)

      if [[ "$remotes" =~ "github" ]]; then
        domain="github.com"
        branchPath="/tree/"
      elif [[ "$remotes" =~ "bitbucket" ]]; then
        domain="bitbucket.org"
        branchPath="/commits/branch/"
      else
        echo "Unable to determine git hosting service."
        return 1
      fi
    fi

    remotes=$(git remote -v | awk -F'git@'$domain: '{print $2}')
    if [ -z "$remotes" ]; then
      remotes=$(git remote -v | awk -F'https://'$domain/ '{print $2}')
    fi

    remoteClean=$(echo "$remotes" | head -n 1 | sed 's/.git//')
    remoteURL=$(echo "$remoteClean" | cut -d" " -f1)
    username=$(echo "$remoteClean" | sed 's/\/.*$//')
    reponame=$(echo "$remoteClean" | sed 's/^[^/]*\/\([^ ]*\).*$/\1/')
    branch=$(git rev-parse --abbrev-ref HEAD)

    if [[ "$branch" = "gh-pages" && -n "$username" && -n "$reponame" ]]; then
      open "http://${username}.github.io/${reponame}"
      return
    fi

    if [[ -n "$branch" && -n "$remoteURL" && $branch != "master" ]]; then
      branch="${branchPath}${branch}"
    else
      branch=""
    fi

    open "https://${domain}/${remoteURL}${branch}"
  else
    echo "Not a repository."

    if [[ -n "$domain" ]]; then
      open "https://${domain}/"
    fi

    return 1
  fi
}

# git blame colors
function blame() {
  local red=$'\033[31m'
  local green=$'\033[32m'
  local cyan=$'\033[36m'
  local yellow=$'\033[33m'
  local magenta=$'\033[35m'
  local none=$'\033[0m'

  git blame "$1" | sed -E "s/^([0-9a-z^]+)([^(]*)( +)\(([A-Za-z ]+)( +)([0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2} [-+][0-9]{4})( +)([0-9]+)\)(.*)$/$red\1$none$green\2$none\3($cyan\4$none\5$yellow\6$none\7$magenta\8$none)\9/" | less -R
}

# git list colors
function list() {
  local red=$'\033[31m'
  local green=$'\033[32m'
  local cyan=$'\033[36m'
  local yellow=$'\033[33m'
  local magenta=$'\033[35m'
  local none=$'\033[0m'

  git list | sed -E "s/^(stash@\{[0-9]+\})(: On)([^:]+)(: )([0-9a-z]+)(.*)(\[)([A-Z]{1}[a-z]{2} [0-9]{2}\/[0-9]{2} [0-2][0-9]:[0-5][0-9])(\])$/$green\1$none\2$cyan\3$none\4$red\5$none\6$yellow\7\8\9$none/" | less -R
}

# TODO - write a better repl function!

# objective-c repl
function objcrepl() {
  local NAME="objcrepl"
  local DIR="/tmp/objcrepl"
  local SOURCE="$DIR/$NAME.m"
  local BOILERPLATE="#import \"Foundation/Foundation.h\"\n\n@interface TestClass : NSObject\n@property (strong, nonatomic) NSString* key;\n@end\n\n@implementation TestClass\n@end\n\nint main () {\n  @autoreleasepool {\n    \n    NSLog(@\"Hello world!\");\n  }\n  return 0;\n}\n"

  if [[ ! -f $SOURCE ]]; then
    mkdir -p $DIR && echo "$BOILERPLATE" > $SOURCE
  fi

  s -w -n $SOURCE && objcreplrun
}

# objctive-c repl - run
function objcreplrun() {
  local NAME="objcrepl"
  local DIR="/tmp/objcrepl"
  local EXE="$DIR/$NAME"

  clang -fobjc-arc -Weverything -Wno-newline-eof -framework Foundation -o $EXE $DIR/*.m && echo "----------[ /tmp/objcrepl ]----------" && (exec $EXE)
}

function cppreplrun() {
  local NAME="objcrepl"
  local DIR="/tmp/objcrepl"
  local EXE="$DIR/$NAME"

  clang++ -Os -fobjc-arc -framework Foundation -lz -ObjC++ -std=gnu++14 -stdlib=libc++ -o $EXE $DIR/*.m && echo "----------[ /tmp/cpprepl ]----------" && (exec $EXE)
}

# swift repl
function swiftrepl() {
  local NAME="swiftrepl"
  local DIR="/tmp/swiftrepl"
  local SOURCE="$DIR/$NAME.swift"
  local BOILERPLATE="#!/usr/bin/swift\n\nimport Foundation\n\n"

  if [[ ! -f $SOURCE ]]; then
    mkdir -p $DIR && echo "$BOILERPLATE" > $SOURCE
    chmod +x $SOURCE
  fi

  v $SOURCE && echo "----------[ /tmp/swiftrepl ]----------" && (exec "$SOURCE")
}

# python repl
funcion pythonrepl() {
  local NAME="pythonrepl"
  local DIR="/tmp/python"
  local SOURCE="$DIR/$NAME.py"
  local BOILERPLATE=""

  if [[ ! -f $SOURCE ]]; then
    mkdir -p $DIR && echo "$BOILERPLATE" > $SOURCE
    chmod +x $SOURCE
  fi

  v $SOURCE && echo "----------[ /tmp/pythonrepl ]----------" && (python "$SOURCE")
}

# xcode
function xc() {
  local CURRENT_XCODE=$(xcode-select -p | grep -oE 'Xcode[^/]+')
  echo "Using $CURRENT_XCODE"
  if [[ ! -z "$1" ]]; then
    open -a "$CURRENT_XCODE" "$1"
  else
    currentPath=$(pwd)
    originalDirname=$(basename "$currentPath")
    while true; do
      fileXCW=$(find -E "$currentPath" -maxdepth 1 -regex ".*\.xcworkspace" | head -1)
      fileXCP=$(find -E "$currentPath" -maxdepth 1 -regex ".*\.xcodeproj" | head -1)

      if [[ -n "$fileXCW" ]]; then
        open -a "$CURRENT_XCODE" "$fileXCW"
        break
      elif [[ -n "$fileXCP" ]]; then
        open -a "$CURRENT_XCODE" "$fileXCP"
        break
      else
        nextPath=$(find "$currentPath" -mindepth 1 -maxdepth 1 -name "$(basename "$originalDirname")" | head -1)
        allDirs=$(find "$currentPath" -mindepth 1 -maxdepth 1 -type d | grep -v "/.git$")

        if [[ -d $nextPath ]]; then
          currentPath=$nextPath
        elif [[ $(echo "$allDirs" | wc -l | tr -d ' ') == "1" ]]; then
          currentPath=$allDirs
        else
          echo "Unable to find an Xcode project."
          return 1
        fi
      fi
    done
  fi
}


# markdown
function md() {
  local MD_EDITOR="MacDown"
  if [[ ! -z "$1" ]]; then
    open -a $MD_EDITOR "$1"
  else
    currentPath=$(pwd)
    while true; do
      fileReadme=$(find -E "$currentPath" -maxdepth 1 -iregex "readme\.md" | head -1)
      fileMarkdown=$(find -E "$currentPath" -maxdepth 1 -iregex ".*\.md" | head -1)

      if [[ -n "$fileReadme" ]]; then
        open -a $MD_EDITOR "$fileReadme"
        break
      elif [[ -n "$fileMarkdown" ]]; then
        open -a $MD_EDITOR "$fileMarkdown"
        break
      else
        nextPath=$(find "$currentPath" -mindepth 1 -maxdepth 1 -name "$(basename "$currentPath")" | head -1)

        if [[ -d "$nextPath" ]]; then
          currentPath=$nextPath
        else
          echo "Unable to find a Markdown file."
          return 1
        fi
      fi
    done
  fi
}

# from mathiasbynens' .functions
function phpserver() {
  local port="${1:-4000}"
  local ip=$(ipconfig getifaddr en0)
  sleep 1 && open "http://${ip}:${port}/" &
  php -S "${ip}:${port}"
}

# notify when done with operation (and returns the previous command's exit code)
# use with a ";" before the previous command
function notify() {
  local EXIT_CODE=$?
  local MESSAGE="Failure!"
  local SOUND="Basso"

  if (( $EXIT_CODE == 0 )); then
    MESSAGE="Success!"
    SOUND="Glass"
  fi

  if [[ -n "$1" ]]; then
    MESSAGE="$1"
  fi

  (terminal-notifier -message "$MESSAGE" && afplay -v 1 "/System/Library/Sounds/$SOUND.aiff" &) ; (exit $EXIT_CODE)
}

# mkdir then cd
function mkcd() {
  mkdir "$@" && cd "$@"
}

# remove last line from history
function forget() {
  (echo -e "$(tail -n1 "$HISTFILE")\n\n$(cat "$HISTFILE" | wc -l)->\c" && sed -i.bak '$d' "$HISTFILE" && [[ -s "$HISTFILE" ]] && rm $HISTFILE.bak) && echo $(cat "$HISTFILE" | wc -l) || echo "!"
}

# superman
function manz() {
  command man -P "less -p '       $1'" zshbuiltins
}

# override default `man` to search zshbuiltins when necessary
function man() {
  if command man "$1" 2>/dev/null | head -n2 | fgrep -q BUILTIN && [[ $1 != "builtin" ]]; then
    manz "$1"
  else
    command man "$1"
  fi
}

function trash() {
  mv "$1" ~/.Trash && echo "Moved \"$1\" to Trash"
}


# alert when website is up
#   15 sec timeout on `curl`,
#   15 sec delay before reattempting
#
function upalert() {
  if [[ -n "$1" ]]; then
    echo "Will notify when $1 comes back online..."
    for i in {1..1000}; do curl -Is -m 30 $1 && notify "$1 is back up!" && break; sleep 15; done
  else
    echo "Usage: upalert [address]"
  fi
}


# base64
function encode64 {
  echo "$1" | base64
}

function decode64 {
  echo "$1" | base64 -D
}

# https://coderwall.com/p/-mgtww/debugging-xcode-plugins
function xcd {
  lldb -p "$(ps aux | grep Xcode | grep -v grep | awk '{print $2}')"
}

# generate random temp directory
function randomtempdir {
  echo "/tmp/mktmp_$(date +%Y%m%d%H%M%S)"
}

# emulates ruby's Dir.mktmpdir
function tempdir {
  mkcd "$(randomtempdir)"
  if [[ -n "$1" ]]; then
    mkcd "$1"
  fi
}

function wrapdir {
  newdir=$1
  tempdir="tempdir_$(date +%Y%m%d%H%M%S)"
  mkdir "$tempdir"
  mv $(ls -A | grep -v "$tempdir") "$tempdir"
  mv "$tempdir" "$newdir"
}

# http://www.reddit.com/r/commandline/comments/2tjqz2/favorite_aliases/cnznumu
function g {
  if (( $# > 0 )); then
    git "$@"
  else
    git status
  fi
}

function xcode_plugin_fix {
  local XCODE_UUID=$(defaults read /Applications/Xcode.app/Contents/Info DVTPlugInCompatibilityUUID)
  
  echo "Updating Xcode plugin compatibility with latest UUID\n  $XCODE_UUID\n"

  for plugin in ~/Library/Application\ Support/Developer/Shared/Xcode/Plug-ins/*; do
   local plist="${plugin}/Contents/Info.plist"
   basename $plugin
   if ! grep -q $XCODE_UUID $plist; then
     defaults write "${plugin}/Contents/Info" DVTPlugInCompatibilityUUIDs -array-add $XCODE_UUID
     echo "  \033[32mFixed\033[0m"
   fi
  done
}

function xcode_clean_derived_data {
  local dd_dir=~/Library/Developer/Xcode/DerivedData
  if [ -d "$dd_dir" ]; then
    local filesize="$(du -hcs $dd_dir | tr "	" " " | cut -d " " -f1 | head -1)"
    echo "Removing ${dd_dir} (${filesize})..."
    rm -rf "$dd_dir"
  else
    echo "$dd_dir has already been cleaned"
  fi
}

function gemedit {
  local gemname="$1"
  local cmd="$2"
  local gemlocation

  if [[ -n "$gemname" ]]; then
    gem which "$gemname" > /dev/null 2>&1
    if (($? == 0)); then
      gemlocation="$(dirname "$(gem which "$gemname")")"
    fi
  fi

  if [[ -n "$gemname" && -n "$cmd" && -n "$gemlocation" ]]; then
    case "$cmd" in
      finder)
        finder "$gemlocation";;
      cd)
        cd "$gemlocation";;
      subl)
        subl "$gemlocation";;
    esac
  elif [[ -n "$gemname" && -z "$cmd" && -n "$gemlocation" ]]; then
    subl "$gemlocation"
  elif [[ -z "$gemlocation" ]]; then
   echo "Can't find gem location for \"$gemname\""
  else
    echo "usage: gemedit <gemname> [subl | cd | finder]"
  fi
}

function playground {
  local playground="<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>
    <playground version='5.0' target-platform='ios'>
      <timeline fileName='timeline.xctimeline'/>
    </playground>"
  local swift="import UIKit
import XCPlayground

XCPlaygroundPage.currentPage.liveView"
  local timeline="<?xml version=\"1.0\" encoding=\"UTF-8\"?>
    <Timeline version = \"3.0\">
      <TimelineItems></TimelineItems>
    </Timeline>"

  tempdir
  mkcd "Temp.playground"

  echo "$swift" > Contents.swift
  echo "$playground" > contents.xcplayground
  echo "$timeline" > timeline.xctimeline

  cd ..
  open "Temp.playground"
}

function prdiff {
  if [[ -n "$1" && -n "$2" && -n "$3" && -n "$4" ]]; then
    local REPONAME=$1
    local PRNUMBER=$2
    local LASTSHA=$3
    local CURRENTSHA=$4

    open "https://github.com/${REPONAME}/pull/${PRNUMBER}/files/${LASTSHA}..${CURRENTSHA}"
  else
    echo "Usage: prdiff [repo name] [pull request #] [old SHA] [current SHA]"
  fi
}

function deskcolor {
  if [[ -z "$1" ]]; then
    echo "Usage: deskcolor [reset | <color (#hex, name)>]"
  fi

  local COLOR=$1
  local WALLPAPER_COOKIE=~/.deskcolor
  local CURRENT_WALLPAPER="$(osascript -e 'tell app "finder" to get posix path of (get desktop picture as alias)')"

  # save wallpaper before we replace it with a color
  local PREVIOUS_WALLPAPER="$(cat $WALLPAPER_COOKIE 2> /dev/null)"
  if [[ "$CURRENT_WALLPAPER" != *"deskcolor"* ]]; then
    PREVIOUS_WALLPAPER="$CURRENT_WALLPAPER"
    echo "$CURRENT_WALLPAPER" > $WALLPAPER_COOKIE
  fi

  if [[ "$1" == "reset" ]]; then
    osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$PREVIOUS_WALLPAPER\""
    return 0
  fi

  local COLOR_WALLPAPER="/tmp/deskcolor-$COLOR.png"
  convert -size 100x100 xc:$COLOR $COLOR_WALLPAPER
  osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$COLOR_WALLPAPER\""
}

function grepct {
  local stdin=$(</dev/stdin)
  local total_lines=$(echo $stdin | wc -l | sed -E 's/^ *| *$//g')
  local matching_lines=$(echo $stdin | grep $@ | wc -l | sed -E 's/^ *| *$//g')
  local percent=$(echo "result = (${matching_lines}/${total_lines}) * 100; scale=2; result / 1" | bc -l)
  echo "${percent}% of lines matched the pattern ($matching_lines / $total_lines)"
}
