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

load() {
  :
}

password() {
  local site="$1"
  local pass="$2"
  local iterations="$3"
  local length="$4"

  in="$(initialize "${site}" "${pass}")"
  for i in $(seq $iterations); do
    in="$(hash "${in}")"
  done
  echo "${in}" \
    | sed 's/[^0-9a-zA-Z]//g' \
    | cut -c1-${length/none/}
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
