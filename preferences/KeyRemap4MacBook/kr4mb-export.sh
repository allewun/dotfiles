#!/bin/sh

# run this to import settings

cli=/Applications/KeyRemap4MacBook.app/Contents/Applications/KeyRemap4MacBook_cli.app/Contents/MacOS/KeyRemap4MacBook_cli

$cli set repeat.wait 20
/bin/echo -n .
$cli set remap.fn2controlL 1
/bin/echo -n .
$cli set repeat.initial_wait 333
/bin/echo -n .
$cli set remap.controlDelete2forwarddelete 1
/bin/echo -n .
$cli set caps_lock_to_hyper 1
/bin/echo -n .
$cli set remap.controlL2fn 1
/bin/echo -n .
$cli set remap.eject2forwarddelete 1
/bin/echo -n .
/bin/echo
