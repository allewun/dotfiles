#!/bin/zsh

#==============================================================================
# functions.sh
# Allen Wu (Jan 2014)
#==============================================================================


# show last N of the shell history
# defaults to 10
function histail() {
  if [[ -z "$1" ]]; then
    cat $HISTFILE | tail -10
  else
    cat $HISTFILE | tail -n "$1"
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
  local DIR="/tmp/objcrepl"
  local SOURCE="$DIR/$NAME.m"
  local EXE="$DIR/$NAME"
  local BOILERPLATE="#import \"Foundation/Foundation.h\"\n\n@interface TestClass : NSObject\n@property (strong, nonatomic) NSString* key;\n@end\n\n@implementation TestClass\n@end\n\nint main () {\n  @autoreleasepool {\n    \n    NSLog(@\"Hello world!\");\n  }\n  return 0;\n}\n"

  if [[ ! -f $SOURCE ]]; then
    mkdir -p $DIR && echo $BOILERPLATE > $SOURCE
  fi

  v $SOURCE && clang -fobjc-arc -Weverything -Wno-newline-eof -framework Foundation -o $EXE $DIR/*.m && echo "----------[ /tmp/objcrepl ]----------" && (exec $EXE)
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
#       try to open [file] in vim
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
    cd $DOTFILE_PATH
    return 0
  fi

  # open entire directory
  if [[ "$NEEDLE" == "." ]]; then
    subl $DOTFILE_PATH
    return 0
  fi

  # find file matches
  local FILE=$(find $DOTFILE_PATH -type f -iregex ".*$NEEDLE.*" -maxdepth 1 | head -n1)
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
  elif [[ ! -z "$FILE" ]]; then
    v $FILE && src
  fi
}


# notify when done with operation (and returns the previous command's exit code)
# use with a ";" before the previous command
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

# mkdir then cd
function mkcd() {
  mkdir "$@" && cd "$@"
}

# remove last line from history
function forget() {
  (echo -e "$(cat $HISTFILE | wc -l)->\c" && sed -i.bak '$d' $HISTFILE && [[ -s $HISTFILE ]] && rm $HISTFILE.bak) && echo $(cat $HISTFILE | wc -l) || echo "!"
}

# superman
function manz() {
  command man -P "less -p '       $1'" zshbuiltins
}

# override default `man` to search zshbuiltins when necessary
function man() {
  if command man $1 2>/dev/null | head -n2 | fgrep -q BUILTIN && [[ $1 != "builtin" ]]; then
    manz $1
  else
    command man $1
  fi
}

function trash() {
  mv "$1" ~/.Trash && echo "Moved \"$1\" to Trash"
}

# iOS local ad hoc distribution server
#
# uses Dropbox instead of localhost, since
# iOS 7.1 requires SSL, and I couldn't figure
# out how to get HTTPS to work successfully with
# pythonserver. It almost worked though...
#
# Usage:
#   adhoc(file, bundleID, version, title)
#
function adhoc() {
  if [[ -n $1 && -n $2 && -n $3 && -n $4 ]]; then
    if [[ -f $1 ]]; then

    local FILENAME=$1
    local BUNDLEID=$2
    local VERSION=$3
    local TITLE=$4

    local DROPBOXID=$(kDropboxID)
    local TIMESTAMP=$(date +%Y%m%d%H%M)
    local TIMESTAMP_CLEAN="$(date "+%B %d @ %l:%M:%S %p")"
    local DIR="$HOME/Dropbox/Public/adhoc/$TIMESTAMP"
    local SERVER="https://dl.dropboxusercontent.com/u/$DROPBOXID/adhoc/$TIMESTAMP"
    local FILESIZE=$(ls -lh $FILENAME | tr -s ' ' | cut -d" " -f5)

    local HTML="
<html>
  <head>
    <title>$TITLE -- Ad Hoc Distribution</title>
    <style>*{margin:0;padding:0;font-family:'Gill Sans';font-size:50px}body{background:#e9edf2;background:linear-gradient(to bottom,#fff 0,#e2e7ee 20%,#e2e7ee 100%);color:#333}a{border:1px solid #284352;background:#00ff7e;color:#fff;box-shadow:inset 0 0 20px rgba(0,0,0,.4),0 8px 0 #fff;text-shadow:0 5px 0 #007c3c,0 -1px 2px rgba(0,0,0,.3);font-size:80px;text-align:center;margin:40px auto;width:600px;height:600px;display:block;border-radius:300px;line-height:600px;text-decoration:none}ul{margin-left:30px;padding:50px}li{padding-left:20px}footer{font-style:italic;color:#284352;padding:50px}</style>
  </head>
  <body>
    <a href=\"itms-services://?action=download-manifest&amp;url=$SERVER/manifest\">$TITLE</a>
    <ul><li>Bundle ID: $BUNDLEID</li><li>Version: $VERSION</li><li>File size: ${FILESIZE}B</li></ul>
    <footer>Generated on $TIMESTAMP_CLEAN</footer>
  </body>
</html>"

    local MANIFEST="
<plist version=\"1.0\">
  <dict>
    <key>items</key>
    <array>
      <dict>
        <key>assets</key>
        <array>
          <dict>
            <key>kind</key><string>software-package</string>
            <key>url</key><string>$SERVER/$FILENAME</string>
          </dict>
        </array>
        <key>metadata</key>
        <dict>
          <key>bundle-identifier</key><string>$BUNDLEID</string>
          <key>bundle-version</key><string>$VERSION</string>
          <key>kind</key><string>software</string>
          <key>title</key><string>$TITLE</string>
        </dict>
      </dict>
    </array>
  </dict>
</plist>"

      mkdir -p $DIR
      cp $FILENAME $DIR/$1
      echo $HTML > "$DIR/index.html"
      echo $MANIFEST > "$DIR/manifest"

      echo ""
      echo "  * Creating iOS Ad Hoc distribution server at:"
      echo "     - $(tput setaf 6)$SERVER/index.html$(tput sgr 0)"
      echo "     - $(tput setaf 3)$DIR$(tput sgr 0)"
      echo ""
      echo "  * $TITLE"
      echo "     - $FILENAME (${FILESIZE}B)"
      echo "     - Bundle ID: $BUNDLEID"
      echo "     - Version  : $VERSION"
    fi
  else
    echo "Usage: adhoc [FILENAME.ipa] [Bundle ID] [Version] [Title]"
  fi
}
