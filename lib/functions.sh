#!/bin/bash

filter() {
  local filter="$1"
  local length="$2"
  sed "${filter/none/}" | cut -c1-${length/none/}
}

initialize() {
  site="${1:-}"
  iterations="${2:-}"
  length="${3:-}"
  filter="${4:-}"
  pass="${5:-}"
}

iterations() {
  echo -n "$1" | wc -m
}

password() {
  local site="$1"
  local pass="$2"
  local iterations="$3"
  local length="$4"

  local pass="$(echo -n "${site}${pass}" | encode)"
  for _ in $(seq $iterations); do
    pass="$(echo "${pass}" | decode | sha1 | encode)"
  done
  echo "${pass}"
}
