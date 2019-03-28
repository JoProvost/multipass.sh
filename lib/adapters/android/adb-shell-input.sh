#!/bin/bash

if [ -f adb-shell.sh ]; then
  . adb-shell.sh
fi

_adb_type_password() {
  adb_shell input keyevent KEYCODE_APP_SWITCH
  adb_shell input keyevent KEYCODE_APP_SWITCH
  sleep 2
  adb_shell input text "$1"
}

if use_adb_shell; then
  type_password() { _adb_type_password "$@"; }
fi
