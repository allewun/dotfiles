#!/bin/bash

osascript <<EOD
  tell application "Finder"
    activate
    make new Finder window
  end tell
EOD