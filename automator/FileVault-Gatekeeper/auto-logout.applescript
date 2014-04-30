set cmdKeyDown to (do shell script "/usr/local/bin/keys cmd")

if cmdKeyDown ­ "1" then
	tell application "loginwindow" to «event aevtrlgo»
else
	do shell script "afplay /System/Library/Sounds/Glass.aiff"
end if