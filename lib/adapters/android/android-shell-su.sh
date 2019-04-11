#!/bin/bash

android_shell_su() {
  local c=''
  for i in "$@"; do
    i="${i//\\/\\\\}"
    c="${c:+${c} }\"${i//\"/\\\"}\""
  done
  su -c "${c}"
}

use_android_shell_su() {
  which su >/dev/null && return 0 || return 1
}
