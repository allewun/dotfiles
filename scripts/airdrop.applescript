#!/usr/bin/osascript
tell application "Finder"
	activate
	tell application "System Events" to keystroke "R" using {command down, shift down}
end tell