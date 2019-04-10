#!/bin/bash

pushd $(dirname $(readlink -f ${BASH_SOURCE[0]})) >/dev/null
. ../../functions.sh
. ../../../lib/adapters/android/android-shell.sh
popd >/dev/null

which() { [ "$1" = "su" ] && return 0 || return 1; }
uname() { echo "Android"; }
android_shell() { error "unchanged android_shell behaviour ($*)"; }
android_shell_adb() { error "unexpected call to android_shell_adb"; }
android_shell_adb_spooler_install() { :; }


test_android_su_used_if_when_su_is_available() {
  su() {
    assert_that "$1" = "-c"
    echo "su -c '$2'"
  }

  load_android_shell

  assert_that "$(android_shell run '"this" command')" = "su -c '\"run\" \"\\\"this\\\" command\"'"
}

test_nothing_when_not_on_android() {
  su() { error "unexpected call to su ($*)"; }
  uname() { echo "Linux"; }
  android_shell() { echo "unchanged android_shell"; }

  load_android_shell

  assert_that "$(android_shell run '"this" command')" = 'unchanged android_shell'
}

test_fallback_to_adb_if_su_is_not_available() {
  su() { error "unexpected call to su ($*)"; }
  which() { return 1; }
  android_shell_adb() { echo "android_shell_adb ($*)";}

  load_android_shell

  assert_that "$(android_shell run '"this" command')" = 'android_shell_adb (run "this" command)'
}

run_test_suite
