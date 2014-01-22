#!/bin/sh

# run this to export settings and replace this file
# /Applications/KeyRemap4MacBook.app/Contents/Applications/KeyRemap4MacBook_cli.app/Contents/MacOS/KeyRemap4MacBook_cli export > ~/dotfiles/preferences/KeyRemap4MacBook/kr4mb-export.sh

# run this to import settings
# . ~/dotfiles/preferences/KeyRemap4MacBook/kr4mb-export.sh

cli=/Applications/KeyRemap4MacBook.app/Contents/Applications/KeyRemap4MacBook_cli.app/Contents/MacOS/KeyRemap4MacBook_cli

$cli set repeat.wait 20
/bin/echo -n .
$cli set repeat.initial_wait 333
/bin/echo -n .
$cli set double_tap_shift_to_caps_lock 1
/bin/echo -n .
$cli set caps_lock_to_hyper 1
/bin/echo -n .
$cli set remap.eject2forwarddelete 1
/bin/echo -n .
$cli set remap.controlL2fn 1
/bin/echo -n .
$cli set remap.fn2controlL 1
/bin/echo -n .
$cli set double_tap_command_to_f18 1
/bin/echo -n .
$cli set parameter.doublepressmodifier_threshold 200
/bin/echo -n .
/bin/echo
