#!/bin/bash

cd $(dirname $(readlink -f ${BASH_SOURCE[0]}))
source ./adb-shell.sh
cd - >/dev/null

_adb_type_password() {
  adb_shell input keyevent KEYCODE_APP_SWITCH
  adb_shell input keyevent KEYCODE_APP_SWITCH
  adb_shell sleep 2
  adb_shell input text "$1"
}

load_adb_shell_input() {
  if use_adb_shell; then
    type_password() { _adb_type_password "$@"; }
  fi
}

[ "${BUILD_MULTIPASS_SH:-}" = "true" ] || load_adb_shell_input
