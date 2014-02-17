#!/bin/zsh

function __heroku_ps1() {
  if git rev-parse --is-inside-git-dir > /dev/null 2>&1; then
    local url=$(git remote -v 2>/dev/null | fgrep -m1 heroku | pcregrep -o1 -i "heroku\.com:([a-z0-9-]+)\.git" 2>/dev/null)
    if [[ -n "$url" ]]; then
      echo " [$url]"
      return 0
    fi
    return 1
  fi
  return 1
}
