#!/bin/bash

fail() {
  echo "$@" >&2
  exit 1
}

ask() {
  if ! [ "${!1:-}" ]; then
    read -p "$2: " -i "${3:-}" in
    test -n "$in"
    eval $1='"$in"'
  fi
}

choose() {
  :
}

secret() {
  read -s -p "$2: " in
  echo ""
  test -n "$in"
  eval $1='"$in"'
}

decode() {
  fail "missing decode feature"
}

encode() {
  fail "missing encode feature"
}

hash() {
  fail "missing hash feature"
}

initialize() {
  local site="$1"
  local pass="$2"

  echo -n "${site}${pass}" | encode
}

iterations() {
  echo -n "$1" | wc -m
}

list() {
  :
}

load() {
  :
}

filter() {
  local filter="$1"
  local length="$2"
  sed "${filter/none/}" | cut -c1-${length/none/}
}

password() {
  local site="$1"
  local pass="$2"
  local iterations="$3"
  local length="$4"

  local hash="$(initialize "${site}" "${pass}")"
  for _ in $(seq $iterations); do
    hash="$(hash "${hash}")"
  done
  echo "${hash}"
}

save() {
  :
}

type_password() {
  echo "$1"
}

web_site() {
  :
}
