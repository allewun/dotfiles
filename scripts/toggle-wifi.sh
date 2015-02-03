#!/usr/bin/env zsh

# http://apple.stackexchange.com/a/37216

device=$(networksetup -listallhardwareports |
grep -E '(Wi-Fi|AirPort)' -A 1 | grep -o en.)
[[ "$(networksetup -getairportpower $device)" == *On ]] && v=off || v=on
networksetup -setairportpower $device $v
