#!/bin/bash

pushd $(dirname $(readlink -f ${BASH_SOURCE[0]})) >/dev/null
source ../functions.sh
source ../../lib/adapters/vault.sh
popd >/dev/null

setup() {
  vault=$(mktemp -d ${TMPDIR:-"/tmp"}/multipass.XXXXXXX)
  VAULT=${vault}
}

teardown() {
  rm -Rf ${vault}
}

test_vault_saves_site_with_empty_parameters() {
  iterations=12

  save my_test_site

  assert_that -f ${vault}/my_test_site
  assert_that "$(cat ${vault}/my_test_site)" = "\
iterations: 12
length: none
filter: none
salt: none"
}

test_vault_saves_site_with_all_parameters() {
  iterations=12
  length=10
  filter="s/[^a-zA-Z]//g"
  salt="some-random-salt"

  save my_test_site

  assert_that -f ${vault}/my_test_site
  assert_that "$(cat ${vault}/my_test_site)" = "\
iterations: 12
length: 10
filter: s/[^a-zA-Z]//g
salt: some-random-salt"
}

test_vault_loads_site_with_all_parameters() {
  cat >${vault}/my_test_site << __EOF
iterations: 22
length: 12
filter: none
salt: some-salt
__EOF

  load my_test_site

  assert_that ${iterations} = 22
  assert_that ${length} = 12
  assert_that ${filter} = "none"
  assert_that ${salt} = "some-salt"
}

test_vault_loads_site_adding_default_values_to_missing_parameters() {
  cat >${vault}/my_test_site << __EOF
iterations: 22
length: 12
__EOF

  load my_test_site

  assert_that ${iterations} = 22
  assert_that ${length} = 12
  assert_that ${filter} = "s/[^0-9a-zA-Z]//g"
  assert_that ${salt} = "none"
}

run_test_suite
