#!/bin/bash

_fail() {
  echo "$@" >&2
  exit 1
}

decode() {
  _fail "missing decode adapter"
}

encode() {
  _fail "missing encode adapter"
}

input() {
  local key="${1}"
  local text="${2:-}"
  local default="${3:-}"

  if ! [ "${!key:-}" ]; then
    read -p "${text:-${key}}: " -i "${default:-}" value
    test -n "${value}"
    eval $1='"${value}"'
  fi
}

list() {
  :
}

load() {
  local site="$1"
}

propose() {
  local key="${1}"
  local text="${2:-}"
  local default="${3:-}"
  local list="${4:-}"
}

question() {
  local key="${1}"
  local text="${2:-}"
  local yes="${3:-true}"
  local no="${4:-false}"

  if ! [ "${!key:-}" ]; then
    _answer=""
    input _answer
    read -p "${text:-${key} ?} (Y/n)" -i "y" _answer

    test -n "${_answer}"

    case "${_answer}" in
      'y') eval $1='"${yes}"' ;;
      *)   eval $1='"${no}"'
    esac
  fi
}

save() {
  local site="$1"
}

secret() {
  local key="${1}"
  local text="${2:-}"

  read -s -p "${text:-${key}}: " value
  echo ""
  test -n "$value"
  eval $1='"$value"'
}

sha1() {
  _fail "missing sha1 adapter"
}

type_password() {
  local password="$1"

  echo "${password}"
}

web_site() {
  :
}
