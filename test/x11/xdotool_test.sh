#!/bin/bash

cd $(dirname $(readlink -f ${BASH_SOURCE[0]}))
. ../functions.sh
. ../../lib/adapters/x11/xdotool.sh
cd - >/dev/null

test_xdotool_loaded_if_available_and_on_x11() {
  type_password() { error "type_password was not replaced by load_xdotool"; }
  which() { true; }
  xdotool() {
    case "$1" in
      '-h')
        echo "Available commands:"
        echo "  type"
        ;;
      *)
        echo xdotool "$@"
    esac
  }

  DISPLAY=":0" load_xdotool

  assert_that "$(type_password "password")" = "xdotool sleep 1 type password"
}

test_xdotool_not_loaded_if_not_on_x11() {
  type_password() { echo "unchanged type_password behaviour"; }
  which() { true; }
  xdotool() {
    case "$1" in
      '-h')
        echo "Available commands:"
        echo "  type"
        ;;
      *)
        echo xdotool "$@"
    esac
  }

  DISPLAY="" load_xdotool

  assert_that "$(type_password "password")" = "unchanged type_password behaviour"
}

test_xdotool_not_loaded_if_xdotool_unavailable() {
  type_password() { echo "unchanged type_password behaviour"; }
  which() { false; }
  xdotool() { error "unexpected call to xdotool"; }

  DISPLAY="" load_xdotool

  assert_that "$(type_password "password")" = "unchanged type_password behaviour"
}

test_xdotool_not_loaded_if_the_tool_is_not_behaving_as_expected() {
  type_password() { echo "unchanged type_password behaviour"; }
  which() { true; }
  xdotool() {
    case "$1" in
      '-h')
        echo "Unexpected help text"
        ;;
      *)
        echo xdotool "$@"
    esac
  }

  DISPLAY="" load_xdotool

  assert_that "$(type_password "password")" = "unchanged type_password behaviour"
}

run_test_suite
