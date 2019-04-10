#!/bin/bash

pushd $(dirname $(readlink -f ${BASH_SOURCE[0]})) >/dev/null
source android-shell.sh
popd >/dev/null

_android_input_type_password() {
  android_shell input keyevent KEYCODE_APP_SWITCH
  android_shell input keyevent KEYCODE_APP_SWITCH
  android_shell sleep 2
  android_shell input text "$1"
}

load_android_input() {
  if use_android_shell; then
    type_password() { _android_input_type_password "$@"; }
  fi
}

[ "${BUILD_MULTIPASS_SH:-}" = "true" ] || load_android_input
