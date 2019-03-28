#!/bin/bash

fail() {
  echo "$@" >&2
  exit 1
}

ask() {
  local key="${1:-}"
  local text="${2:-}"
  local default="${3:-}"

  if ! [ "${!key:-}" ]; then
    read -p "$text: " -i "${default:-}" value
    test -n "$value"
    eval $1='"$value"'
  fi
}

decode() {
  fail "missing decode adapter"
}

encode() {
  fail "missing encode adapter"
}

list() {
  :
}

load() {
  local site="$1"
}

propose() {
  local key="${1:-}"
  local text="${2:-}"
  local default="${3:-}"
  local list="${4:-}"
}

save() {
  local site="$1"
}

secret() {
  local key="${1:-}"
  local text="${2:-}"

  read -s -p "$text: " value
  echo ""
  test -n "$value"
  eval $1='"$value"'
}

sha1() {
  fail "missing sha1 adapter"
}

type_password() {
  local password="$1"

  echo "$password"
}

web_site() {
  :
}
