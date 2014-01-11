#!/bin/zsh

function __rbenv_ps1() {
  if rbenv version > /dev/null 2>&1; then
    local VERSION=$(rbenv version-name)
    if rbenv version | fgrep -q '.ruby-version'; then
      echo " [$VERSION]"
    else
      return 1
    fi
  else
    return 1
  fi
}
