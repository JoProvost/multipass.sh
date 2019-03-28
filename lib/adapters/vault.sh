#!/bin/bash

VAULT=${VAULT:-"${HOME}/d/crypt"}

list() {
  ls -1 "${VAULT}"
}

load() {
  local site="$1"

  if [ -f "${VAULT}/${site}" ]; then
    eval "$(sed -e 's/:[^:\/\/]/="/g;s/$/"/g;s/ *=/=/g' "${VAULT}/${site}")"
    filter="${filter:-"s/[^0-9a-zA-Z]//g"}"
  fi
}

save() {
  local site="$1"

  if ! [ -f "${VAULT}/${site}" ]; then
    mkdir -p "${VAULT}"
    cat >  "${VAULT}/${site}"  << ____EOF
iterations: $iterations
length: ${length:-none}
filter: ${filter:-none}
____EOF
  fi
}
