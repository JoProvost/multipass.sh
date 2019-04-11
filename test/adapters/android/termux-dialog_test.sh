#!/bin/bash

pushd $(dirname $(readlink -f ${BASH_SOURCE[0]})) >/dev/null
. ../../functions.sh
. ../../../lib/adapters/android/termux-dialog.sh
popd >/dev/null

input() { fail "input unchanged ($*)"; }
secret() { fail "secret unchanged ($*)"; }
question() { fail "question unchanged ($*)"; }
termux-dialog() { fail "termux-dialog unchanged ($*)"; }
which() { true; }

test_termux_dialog_input() {
  load_termux_dialog

  termux-dialog() {
    assert_that "$(command_line "$@")" = 'text -t text -i default'
    echo '{ "code": -1, "text": "value" }'
  }

  some_key=""
  input some_key "text" "default"
  assert_that "${some_key}" = "value";
}

test_termux_dialog_input_without_value_returns_default() {
  load_termux_dialog

  termux-dialog() {
    assert_that "$(command_line "$@")" = 'text -t text -i default'
    echo '{ "code": -1, "text": "" }'
  }

  some_key=""
  input some_key "text" "default"
  assert_that "${some_key}" = "default";
}

test_termux_dialog_input_canceled_returns_empty() {
  load_termux_dialog

  termux-dialog() {
    assert_that "$(command_line "$@")" = 'text -t text -i default'
    echo '{ "code": -2, "text": "" }'
  }

  some_key=""
  input some_key "text" "default" && fail || true
}

test_termux_dialog_question_yes() {
  load_termux_dialog

  termux-dialog() {
    assert_that "$(command_line "$@")" = 'confirm -t text'
    echo '{ "code": -1, "text": "yes" }'
  }

  some_key=""
  question some_key "text" "good" "bad"
  assert_that "${some_key}" = "good";
}

test_termux_dialog_question_no() {
  load_termux_dialog

  termux-dialog() {
    assert_that "$(command_line "$@")" = 'confirm -t text'
    echo '{ "code": -1, "text": "no" }'
  }

  some_key=""
  question some_key "text" "good" "bad"
  assert_that "${some_key}" = "bad";
}

test_termux_dialog_question_cancel() {
  load_termux_dialog

  termux-dialog() {
    assert_that "$(command_line "$@")" = 'confirm -t text'
    echo '{ "code": -2, "text": "no" }'
  }

  some_key=""
  question some_key "text" "good" "bad" && fail || true
}

test_termux_dialog_secret() {
  load_termux_dialog

  termux-dialog() {
    assert_that "$(command_line "$@")" = 'text -p -t text'
    echo '{ "code": -1, "text": "value" }'
  }

  some_key=""
  secret some_key "text"
  assert_that "${some_key}" = "value";
}

test_termux_dialog_secret_canceled() {
  load_termux_dialog

  termux-dialog() {
    assert_that "$(command_line "$@")" = 'text -p -t text'
    echo '{ "code": -2, "text": "value" }'
  }

  some_key=""
  secret some_key "text" && fail || true
}

run_test_suite
