#!/bin/bash

cd $(dirname $(readlink -f ${BASH_SOURCE[0]}))
. functions.sh
. ../lib/shell.sh
cd - >/dev/null

test_generating_a_password_with_all_setings_from_command_line() {
  load() { :; }
  save() { :; }
  secret() { eval $1='"master_password"'; }
  type_password() { echo "$1"; }

  assert_that "$( pass "site" "4" "none" "s/[^0-9a-zA-Z]//g" )" = "LpzFqyeTVIhpglEIaxHaZrGRIw"
}

run_test_suite
