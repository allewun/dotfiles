#!/bin/sh

# run this to export settings and replace this file
# /Applications/Karabiner.app/Contents/Library/bin/karabiner export > ~/dotfiles/preferences/Karabiner/kr4mb-export.sh

# run this to import settings
# . ~/dotfiles/preferences/Karabiner/karabiner-export.sh


cli=/Applications/Karabiner.app/Contents/Library/bin/karabiner

$cli set double_tap_alt_to_f17 1
/bin/echo -n .
$cli set repeat.initial_wait 400
/bin/echo -n .
$cli set remap.fn_consumer_to_fkeys_f7 1
/bin/echo -n .
$cli set parameter.doublepressmodifier_threshold 200
/bin/echo -n .
$cli set double_tap_shift_to_caps_lock 1
/bin/echo -n .
$cli set remap.controlL2fn 1
/bin/echo -n .
$cli set double_tap_command_to_f18 1
/bin/echo -n .
$cli set remap.fn_consumer_to_fkeys_f10 1
/bin/echo -n .
$cli set remap.fn_consumer_to_fkeys_f1 1
/bin/echo -n .
$cli set repeat.wait 20
/bin/echo -n .
$cli set remap.fn_consumer_to_fkeys_f3 1
/bin/echo -n .
$cli set general.workaround_stuck_keyboards 1
/bin/echo -n .
$cli set caps_lock_to_hyper 1
/bin/echo -n .
$cli set remap.eject2forwarddelete 1
/bin/echo -n .
$cli set remap.fn2controlL 1
/bin/echo -n .
$cli set remap.fn_consumer_to_fkeys_f5 1
/bin/echo -n .
/bin/echo
