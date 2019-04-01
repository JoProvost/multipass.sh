#!/bin/bash
# https://github.com/ebranlard/xdotool-for-windows

cd $(dirname $(readlink -f ${BASH_SOURCE[0]}))
. ./windows.sh
cd - >/dev/null

_xdotool_for_windows_type_password() {
  sleep 1
  xdotool key "$1"
}

_use_xdotool_for_windows() {
  use_windows && which xdotool >/dev/null && return 0 || return 1
}

load_xdotool_for_windows() {
    if _use_xdotool_for_windows; then
      type_password() { _xdotool_for_windows_type_password "$@"; }
    fi
}

load_xdotool_for_windows
