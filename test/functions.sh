#!/bin/bash

setup() { :; }
teardown() { :; }

run_test_suite() {
  errors=0
  echo "$0"
  for test in $( typeset -F | cut -d ' ' -f 3 | grep ^test_ ); do
    standard_errors=$(mktemp ${TMPDIR:-"/tmp"}/multipass.XXXXXXX)
    echo -n "  ${test}"
    setup
    (
      if ${test} 2>${standard_errors} && [ "$(wc -l < ${standard_errors})" -eq 0 ]; then
        echo " ✔"
      else
        echo " 😭"
        sed 's/^/   /g' ${standard_errors} >&2
        exit 1
      fi
    )
    errors=$(( errors + $? ))
    teardown
    rm ${standard_errors}
  done
  echo ""
  exit $errors
}

assert_that() {
  if ! test "$@"; then
    error assert_that "$@"
    return 1
  fi
}

fail() {
  error Failed "$@"
}

command_line() {
  local c=''
  for i in "$@"; do
    i="${i//\\/\\\\}"
    i="${i//\"/\\\"}"
    [[ "${i}" =~ ( |\') ]] && i="\"${i}\""
    c="${c:+${c} }${i}"
  done
  echo "${c}"
}

readonly project_root=$(dirname $(dirname $(readlink -f ${BASH_SOURCE[0]})))
error() {
  echo "> Error: $(command_line "${@}")" >&2
  if [ ${#FUNCNAME[@]} -gt 2 ]; then
    echo "  Call stack:"
    for ((i=1;i<${#FUNCNAME[@]}-1;i++)); do
      echo "    at ${FUNCNAME[$i]}($(find ${project_root} -name $(basename ${BASH_SOURCE[$i+1]})):${BASH_LINENO[$i]})"
    done
  fi >&2
  echo "" >&2
}
