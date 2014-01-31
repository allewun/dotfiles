#!/bin/zsh

function __arrow_ps1() {
  # default
  if [[ `hostname` == "Allens-MacBook-Pro.local" ]]; then
    echo ">"
  # vpn, others?
  else
    echo "$"
  fi
}
