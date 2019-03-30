#!/bin/bash

assert_error=

run_test_suite() {
  errors=0
  echo "$0"
  for test in $( typeset -F | cut -d ' ' -f 3 | grep ^test_ ); do
    (
      echo -n "  ${test}"
      if ${test}; then
        echo " ✔"
      else
        echo " 😭"
        echo "    ${assert_error:-unknown error}"
        exit 1
      fi
    )
    errors=$(( errors + $? ))
  done
  exit $errors
}

assert_that() {
  if ! test "$@"; then
    assert_error="assert_that $*"
    return 1
  fi
}
