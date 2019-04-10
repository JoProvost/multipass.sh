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
  which su && return 0 || return 1
}
