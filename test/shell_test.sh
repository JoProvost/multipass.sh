#!/bin/bash

cd $(dirname $(readlink -f ${BASH_SOURCE[0]}))
. ./functions.sh
. ../lib/shell.sh
cd - >/dev/null

propose() { :; }
ask() { :; }
load() { :; }
save() { :; }
secret() { eval $1='"master_password"'; }
type_password() { echo "$1"; }
web_site() { :; }


test_generating_a_password_with_all_setings_from_command_line() {
  assert_that "$( pass "site_name" "4" "none" "s/[^0-9a-zA-Z]//g" )" = "YWP1L6hVyJRq5noiQEqnrsOh4U"
}

test_generating_a_password_will_ask_all_setting_to_the_user() {
  ask() {
    case $1 in
      site)       site='site' ;;
      iterations) iterations='4' ;;
      length)     length='none' ;;
      filter)     filter='s/[^0-9a-zA-Z]//g' ;;
    esac
  }

  assert_that "$( pass )" = "LpzFqyeTVIhpglEIaxHaZrGRIw"
}

test_generating_a_password_asking_for_site_and_loading_the_rest_from_vault() {
  load() {
    case $1 in
      'site_name')
        iterations='4'
        length='none'
        filter='s/[^0-9a-zA-Z]//g'
      ;;
    esac
  }
  ask() {
    case $1 in
      site) site='site_name' ;;
    esac
  }

  assert_that "$( pass )" = "YWP1L6hVyJRq5noiQEqnrsOh4U"
}

test_generating_a_password_proposes_a_list_of_known_sites() {
  web_site() { echo "web_site_1"; }
  list() { echo "known_site_1"; echo "known_site_2"; }

  propose() {
    local key="${1:-}"
    local text="${2:-}"
    local default="${3:-}"
    local list="${4:-}"

    assert_that "$key" = "site"
    assert_that "$default" = "$( echo "web_site_1" )"
    assert_that "$(cat $list)" = "$( echo "known_site_1"; echo "known_site_2" )"

    site='known_site_1'
  }

  load() {
    case $1 in
      'known_site_1')
        iterations='4'
        length='none'
        filter='s/[^0-9a-zA-Z]//g'
      ;;
    esac
  }

  assert_that "$( pass )" = "DAQLSJdqWtglhXqoQnMiwTnR4x4"
}


run_test_suite
