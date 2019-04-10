#!/bin/bash

pushd $(dirname $(readlink -f ${BASH_SOURCE[0]})) >/dev/null
source android-shell-su.sh
source android-shell-adb.sh
popd >/dev/null

android_shell() {
  "${@}"
}

use_android_shell() {
  uname -a | grep -q Android && return 0 || return 1
}

load_android_shell() {
  if use_android_shell; then
    if use_android_shell_su; then
      android_shell() { android_shell_su "${@}"; }
    else
      android_shell_adb_spooler_install
      android_shell() { android_shell_adb "${@}"; }
    fi
  fi
}

[ "${BUILD_MULTIPASS_SH:-}" = "true" ] || load_android_shell
