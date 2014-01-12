#!/bin/zsh

#==============================================================================
# functions.sh
# Allen Wu (Jan 2014)
#==============================================================================


# show last N of the shell history
# defaults to 10
function histail() {
  if [[ -z "$1" ]]; then
    history 1 | tail -10
  else
    history 1 | tail -n "$1"
  fi
}


# append song to "to download" list
function song() {
  local songfile="/Users/allen/Dropbox/dl.txt";

  if [[ -z "$1" ]]; then
    cat $songfile
  else
    echo "$1" >> $songfile
    echo "Added: \"$1\""
  fi
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
    if [ -z $remotes ]; then
      remotes=$(git remote -v | awk -F'https://'$domain/ '{print $2}')
    fi

    remoteClean=$(echo $remotes | head -n 1 | sed 's/.git//')
    remoteURL=$(echo $remoteClean | cut -d" " -f1)
    username=$(echo $remoteClean | sed 's/\/.*$//')
    reponame=$(echo $remoteClean | sed 's/^[^/]*\/\([^ ]*\).*$/\1/')
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

# open repository on github
function hub() {
  repo "github.com" "/tree/"
}

# open repository on bitbucket
function bit() {
  repo "bitbucket.org" "/commits/branch/"
}


# git blame colors
function blame() {
  local red=$(echo '\033[31m')
  local green=$(echo '\033[32m')
  local cyan=$(echo '\033[36m')
  local yellow=$(echo '\033[33m')
  local magenta=$(echo '\033[35m')
  local none=$(echo '\033[0m')

  git blame $1 | sed -E "s/^([0-9a-z^]+)([^(]*)( +)\(([A-Za-z ]+)( +)([0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2} [-+][0-9]{4})( +)([0-9]+)\)(.*)$/$red\1$none$green\2$none\3($cyan\4$none\5$yellow\6$none\7$magenta\8$none)\9/" | less -R
}


# objective-c repl
function objcrepl() {
  local NAME="objcrepl"
  local DIR="/tmp"
  local SOURCE="$DIR/$NAME.m"
  local EXE="$DIR/$NAME"
  local BOILERPLATE="#import \"Foundation/Foundation.h\"\n\n@interface TestClass : NSObject\n@property (strong, nonatomic) NSString* key;\n@end\n\n@implementation TestClass\n@end\n\nint main () {\n  @autoreleasepool {\n    \n    NSLog(@\"Hello world!\");\n  }\n  return 0;\n}\n"

  if [[ ! -f $SOURCE ]]; then
    echo $BOILERPLATE > $SOURCE
  fi

  vim $SOURCE && clang -framework Foundation -o $EXE $SOURCE && (exec $EXE)
}


# from mathiasbynens' .functions
function phpserver() {
  local port="${1:-4000}"
  local ip=$(ipconfig getifaddr en0)
  sleep 1 && open "http://${ip}:${port}/" &
  php -S "${ip}:${port}"
}


# quick access to dotfile stuff
#   * dot
#       cd to dotfile directory
#   * dot [name]
#       try to open [file] vim
#   * dot [cmd] [file]
#       perform [cmd] on [file],
#       valid commands are:
#         - open
#         - vim
#         - subl
#         - run
function dot() {
  # determine which arg is the file
  if [[ ! -z "$1" && ! -z "$2" ]]; then
    local NEEDLE=$2
  elif [[ ! -z "$1" ]]; then
    local NEEDLE=$1
  else
    cd $DOTFILE_LOCATION
    return 0
  fi

  # open entire directory
  if [[ "$NEEDLE" == "." ]]; then
    subl $DOTFILE_LOCATION
    return 0
  fi

  # find file matches
  local FILE=$(find $DOTFILE_LOCATION -type f -iregex ".*$NEEDLE.*" -maxdepth 1 | head -n1)
  if [[ -z "$FILE" ]]; then
    echo "No matches for $1."
    return 1
  fi

  # dot [cmd] [file]
  if [[ ! -z "$1" && ! -z "$2" ]]; then
    local BASENAME=$(basename $FILE)
    case "$1" in
      open) ;&
      vim)
        v $FILE && src;;
      subl)
        subl -w $FILE && src;;
      run)
        echo "[Running $BASENAME...]" && source $FILE && echo "[Ran $BASENAME]" || echo "[Couldn't run $BASENAME]" ;;
      *)
        echo "Usage: $0 [open|vim|subl|run] FILE"
    esac

  # dot [file]
  elif [[ ! -z "$1" ]]; then
    v $FILE && src
  fi
}


# notify when done with operation
function notify() {
  local EXIT_CODE=$?
  local MESSAGE="Failure!"
  local SOUND="Basso"

  if (( $EXIT_CODE == 0 )); then;
    MESSAGE="Success!"
    SOUND="Glass"
  fi

  (terminal-notifier -message $MESSAGE && afplay -v 1 "/System/Library/Sounds/$SOUND.aiff" &) ; (exit $EXIT_CODE)
}
