#!/bin/zsh

function __rbenv_ps1() {
  if rbenv version > /dev/null 2>&1; then
    local VERSION=$(rbenv version-name)

    if rbenv version | fgrep -q '.ruby-version'; then
      local GEMSETS=$(rbenv gemset active 2>/dev/null | sed "s/[[:<:]]global[[:>:]]//g" | sed -E "s/^ +| +$//g" | sed -E "s/ +/, /g")
      echo " [$VERSION$( [[ -n $GEMSETS ]] && echo " / $GEMSETS" )]"
      return 0
    fi
  fi
  return 1
}
