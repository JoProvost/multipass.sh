#!/bin/bash

pushd $(dirname $(readlink -f ${BASH_SOURCE[0]})) >/dev/null
. ../../functions.sh
. ../../../lib/adapters/android/android-input.sh
popd >/dev/null

android_shell() { echo "android_shell $*"; }
use_android_shell() { true; }
type_password() { :; }


test_type_password_switches_back_to_previous_app_and_types_the_password() {
  load_android_input

  assert_that "$(type_password 'my_password')" = "\
android_shell input keyevent KEYCODE_APP_SWITCH
android_shell input keyevent KEYCODE_APP_SWITCH
android_shell sleep 2
android_shell input text my_password"
}

test_type_password_stays_unchanged_when_not_on_android() {
  use_android_shell() { false; }
  type_password() { echo "unchanged type_password"; }

  load_android_input

  assert_that "$(type_password 'my_password')" = "unchanged type_password"
}


run_test_suite
