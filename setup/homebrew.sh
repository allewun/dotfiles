#!/usr/bin/env zsh

# ensure homebrew can write to the dirs it needs
for dir in /usr/local/bin /usr/local/lib /usr/local/sbin; do
  if [[ ! -w "$dir" ]]; then
    echo "❌ Homebrew requires '$dir' to be writeable".
    echo
    echo 'sudo chown -R $(whoami) /usr/local/bin /usr/local/lib /usr/local/sbin'
    exit 1
  fi
done

brew bundle --verbose

echo "✅ Done."
