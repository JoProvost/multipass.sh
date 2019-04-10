#!/bin/bash

pushd $(dirname $(readlink -f ${BASH_SOURCE[0]})) >/dev/null
. ../../functions.sh
. ../../../lib/adapters/windows/xdotool-for-windows.sh
popd >/dev/null

test_xdotool_for_windows_loaded_if_available_and_on_windows() {
  type_password() { error "type_password was not replaced by load_xdotool (called with $1)"; }
  use_windows() { true; }
  which() { true; }
  xdotool() { echo xdotool "$@"; }

  load_xdotool_for_windows

  assert_that "$(type_password "password")" = "xdotool key password"
}

test_xdotool_for_windows_not_loaded_if_not_on_windows() {
  type_password() { echo "unchanged type_password behaviour"; }
  use_windows() { false; }
  which() { true; }
  xdotool() { echo xdotool "$@"; }

  load_xdotool_for_windows

  assert_that "$(type_password "password")" = "unchanged type_password behaviour"
}

test_xdotool_for_windows_not_loaded_if_xdotool_unavailable() {
  type_password() { echo "type_password $1"; }
  which() { false; }
  xdotool() { error "unexpected call to xdotool"; }

  load_xdotool_for_windows

  assert_that "$(type_password "password")" = "type_password password"
}

run_test_suite
