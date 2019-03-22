#!/bin/bash

_use_xdotool() {
  which xdotool >/dev/null && return 0 || return 1
}

_xdotool_type_password() {
  xdotool sleep 1 type "$1"
}

if _use_xdotool; then
  type_password() { _xdotool_type_password "$@"; }
fi
