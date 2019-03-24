#!/bin/bash

VAULT=${VAULT:-"${HOME}/d/crypt"}

load() {
  if [ -f "${VAULT}/${1}" ]; then
    eval "$(sed -e 's/:[^:\/\/]/="/g;s/$/"/g;s/ *=/=/g' "${VAULT}/${1}")"
    filter="${filter:-"s/[^0-9a-zA-Z]//g"}"
  fi
}

save() {
  if ! [ -f "${VAULT}/${1}" ]; then
    mkdir -p "${VAULT}"
    cat >  "${VAULT}/${1}"  << ____EOF
iterations: $iterations
length: ${length:-none}
filter: ${filter:-none}
____EOF
  fi
}
