function ensure_installed() {
  if ! hash "$1" 2>/dev/null; then
    return 1
  fi
}

function logsetup() {
  echo "$fg[cyan]Setting up $1...$reset_color"
}

function indent {
  local count=$1
  if [ -z "$1" ]; then count=2; fi
  local spaces="$(printf "%${count}s")"

  sed -e "s/^/${spaces}/"
}
