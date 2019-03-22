#!/bin/bash

_zenity_ask() {
  if ! [ "${!1:-}" ]; then
    local in="$(zenity --entry --title="$TITLE" --text="$2" ${3+--entry-text=${3:-}})"
    [ -n "$in" ]
    eval $1='"$in"'
  fi
}

_zenity_secret() {
  local in="$(zenity --password --title="$TITLE")"
  [ -n "$in" ]
  eval $1='"$in"'
}

_use_zenity() {
  which zenity >/dev/null && return 0 || return 1
}

if _use_zenity; then
  ask() { _zenity_ask "$@"; }
  secret() { _zenity_secret "$@"; }
fi
