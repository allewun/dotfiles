#!/bin/bash

# https://github.com/binaryage/totalterminal-osax/commit/4cc883ec1c2feab07ffd5973bd70b8d5d2ddcb11

osascript <<EOD
tell application "Terminal"
  try
    set res to («event BATTvih_»)
    if res then
      try
        «event BATTvish»
      end try
    else
      try
        «event BATTvihd»
      end try
    end if
  end try
end tell
EOD
