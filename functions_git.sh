#!/usr/bin/env zsh

function gitsnapshot {
  local tag="[GIT SNAPSHOT]"
  if [[ -n "$1" ]]; then
    tag="[GIT SNAPSHOT: $1]"
  fi

  local hash="$(git rev-parse --short HEAD)"
  local commit_msg="$(git log --format=%B -n1 HEAD)"
  local date="$(date +'%a %m/%d %H:%M')"

  git stash save --include-untracked "$tag $hash $commit_msg [$date]" && git stash apply "stash@{0}"
}

function gitsnapshotapply {
  results=$(git stash list | grep "\[GIT SNAPSHOT: $1\]")
  if [[ -n "$results" ]]; then
    git stash apply $(echo "$results" | head -1 | grep -oe "^stash@{[0-9]\{1,\}}")
  else
    echo "Couldn't find snapshot matching \"$1\""
  fi
}

