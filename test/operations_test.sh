#!/bin/bash

pushd $(dirname $(readlink -f ${BASH_SOURCE[0]})) >/dev/null
. ./functions.sh
. ../lib/operations.sh
popd >/dev/null

test_filter_removes_undesired_characters() {
  assert_that "$( echo "ab1/cde34_=fg56" | filter "s/[^0-9a-zA-Z]//g" "none" )" = "ab1cde34fg56"
}

test_filter_limits_the_number_of_characters() {
  assert_that "$( echo "ab1/cde34_=fg56" | filter "none" "5" )" = "ab1/c"
}

test_filter_removes_undesired_characters_and_limits_the_number_of_characters() {
  assert_that "$( echo "ab1/cde34_=fg56" | filter "s/[^0-9a-zA-Z]//g" "5" )" = "ab1cd"
}

test_initialize_without_parameters() {
  initialize

  assert_that "$site" = ""
  assert_that "$iterations" = ""
  assert_that "$length" = ""
  assert_that "$filter" = ""
  assert_that "$salt" = ""
  assert_that "$pass" = ""
}

test_initialize_with_the_site_name() {
  initialize "my_password_protected_site"

  assert_that "$site" = "my_password_protected_site"
  assert_that "$iterations" = ""
  assert_that "$length" = ""
  assert_that "$filter" = ""
  assert_that "$salt" = ""
  assert_that "$pass" = ""
}

test_initialize_with_all_possible_parameters() {
  initialize "site_name" "nb_iterations" "limit_of_characters" "filter_to_apply" "salt" "master_password_never_do_that"

  assert_that "$site" = "site_name"
  assert_that "$iterations" = "nb_iterations"
  assert_that "$length" = "limit_of_characters"
  assert_that "$filter" = "filter_to_apply"
  assert_that "$salt" = "salt"
  assert_that "$pass" = "master_password_never_do_that"
}

test_iterations_suggest_the_number_of_iterations_based_on_length_of_site_name() {
  assert_that "$(iterations "abcdefghi" )" = "9"
}

test_password_with_one_iteration() {
  encode() { echo "$(cat) | encode"; }
  decode() { echo "$(cat) | decode"; }
  sha1() { echo "$(cat) | sha1"; }

  assert_that "$( password "(site)" "(pass)" "(salt)" "1" )" = "(site)(pass)(salt) | encode | decode | sha1 | encode"
}

test_password_with_one_iteration_without_salt() {
  encode() { echo "$(cat) | encode"; }
  decode() { echo "$(cat) | decode"; }
  sha1() { echo "$(cat) | sha1"; }

  assert_that "$( password "(site)" "(pass)" "none" "1" )" = "(site)(pass) | encode | decode | sha1 | encode"
}

test_password_with_two_iterations() {
  encode() { echo "$(cat) | encode"; }
  decode() { echo "$(cat) | decode"; }
  sha1() { echo "$(cat) | sha1"; }

  assert_that "$( password "(site)" "(pass)" "(salt)" "2" )" = "(site)(pass)(salt) | encode | decode | sha1 | encode | decode | sha1 | encode"
}

test_salt() {
  assert_that $(salt | wc -m) = 32
}

test_suggested_site() {
  web_site() { echo "https://github.com/JoProvost/multipass.sh"; }
  assert_that $(suggested_site) = "github"

  web_site() { echo "https://www.google.com/"; }
  assert_that $(suggested_site) = "google"
}


run_test_suite
