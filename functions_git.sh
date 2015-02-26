#!/usr/bin/env zsh

function gitsnapshot {
  local tag="[GIT SNAPSHOT]"
  if [[ -n "$1" ]]; then
    tag="[GIT SNAPSHOT: $1]"
  fi

  local hash="$(git rev-parse --short HEAD)"
  local commit_msg="$(git log --format=%B -n1 HEAD | head -1)"
  local date="$(date +'%a %m/%d %H:%M')"

  git stash save --include-untracked "$tag $hash $commit_msg [$date]" && git stash apply "stash@{0}" > /dev/null
}

function gitsnapshotapply {
  ref=$(gitsnapshotref $@)
  if [[ -n "$ref" ]]; then
    git stash apply "$ref"
  else
    echo "Couldn't find git snapshot matching \"$1\""
  fi
}

function gitsnapshotundo {
  ref=$(gitsnapshotref $@)
  if [[ -n "$ref" ]]; then
    git stash show -p "$ref" | git apply --reverse
  else
    echo "Couldn't find git snapshot matching \"$1\""
  fi
}

function gitsnapshotref {
  results=$(git stash list | grep "\[GIT SNAPSHOT: $1\]")
  if [[ -n "$results" ]]; then
    echo "$results" | head -1 | grep -oe "^stash@{[0-9]\{1,\}}"
  fi
}