#!/bin/bash

VAULT=${VAULT:-"${HOME}/.multipass.sh"}

list() {
  ls -1 "${VAULT}"
}

load() {
  local site="$1"

  if [ -f "${VAULT}/${site}" ]; then
    eval "$(sed -e 's/:[^:\/\/]/="/g;s/$/"/g;s/ *=/=/g' "${VAULT}/${site}")"
    filter="${filter:-"s/[^0-9a-zA-Z]//g"}"
    salt="${salt:-none}"
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
salt: ${salt:-none}
____EOF
  fi
}
