#!/bin/bash

# Get current URL from Firefox
# These experimentally placed delays seem to work okay
# It seems flaky without the delays (sometimes picks up the wrong URL or doesn't capture anything)
active_url=$(osascript <<EOF
tell application "Firefox" to activate
delay 0.05
tell application "System Events"
    keystroke "l" using command down
    delay 0.05
    keystroke "c" using command down
    key code 97
end tell
delay 0.05
return the clipboard
EOF
)

echo "Current Active URL in Firefox: $active_url"
