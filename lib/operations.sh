#!/bin/bash

pushd $(dirname $(readlink -f ${BASH_SOURCE[0]})) >/dev/null
source ./adapters.sh
popd >/dev/null

source_all() {
  for adapter in "${@}"; do source ${adapter}; done
}

filter() {
  local filter="$1"
  local length="$2"
  sed "${filter/none/}" | cut -c1-${length/none/}
}

salt() {
  cat /dev/urandom | tr -dc "a-zA-Z0-9@#%^&*()_+?><~" | head -c32
}

initialize() {
  site="${1:-}"
  iterations="${2:-}"
  length="${3:-}"
  filter="${4:-}"
  salt="${5:-}"
  pass="${6:-}"
}

iterations() {
  echo $(echo -n "$1" | wc -m)
}

suggested_site() {
  echo $(web_site) | cut -d'/' -f3 | cut -d':' -f1  | rev | cut -d. -f2 | rev
}

password() {
  local site="$1"
  local pass="$2"
  local salt="$3"
  local iterations="$4"

  local pass="$(echo -n "${site}${pass}${salt/none/}" | encode)"
  for _ in $(seq $iterations); do
    pass="$(echo "${pass}" | decode | sha1 | encode)"
  done
  echo "${pass}"
}
