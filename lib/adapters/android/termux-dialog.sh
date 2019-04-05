#!/bin/bash

_termux_dialog_input() {
  if ! [ "${!1:-}" ]; then
    local in="$(termux-dialog text -t "$TITLE" -i "$2" | jq -r .text)"
    [ -n "$in" ]
    eval $1='"$in"'
  fi
}

_termux_dialog_secret() {
  local in="$(termux-dialog text -p -t "$TITLE" | jq -r .text)"
  [ -n "$in" ]
  eval $1='"$in"'
}

_use_termux_dialog() {
  which termux-dialog >/dev/null && return 0 || return 1
}

if _use_termux_dialog; then
  input() { _termux_dialog_input "$@"; }
  secret() { _termux_dialog_secret "$@"; }
fi
