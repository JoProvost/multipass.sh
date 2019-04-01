#!/bin/bash

cd $(dirname $(readlink -f ${BASH_SOURCE[0]}))
. ./x11.sh
cd - >/dev/null

_zenity_ask() {
  local key="${1:-}"
  local text="${2:-}"
  local default="${3:-}"

  if ! [ "${!key:-}" ]; then
    local value="$( zenity --entry --title="$TITLE" --text="$text" ${3+--entry-text=${default:-}} )"
    [ -n "$value" ]
    eval $key='"$value"'
  fi
}

_zenity_propose() {
  local key="${1:-}"
  local text="${2:-}"
  local default="${3:-}"
  local list="${4:-}"

  if ! [ "${!key:-}" ]; then
    local value="$(
      (echo "📝 Nouveau ...";
       [ -n "$default" ] && echo "🔍 Suggestion: $default";
       echo "";
       cat $list) | \
      zenity --list --column= --hide-header --title="$TITLE" --text="$text"
    )"
    [ -n "$value" ]
    value="${value/📝 Nouveau .../}"
    value="${value/🔍 Suggestion: /}"
    eval $key='"$value"'
  fi
}

_zenity_secret() {
  local key="${1:-}"
  local text="${2:-}"

  local value="$( zenity --password --title="$TITLE" --text="$text" )"
  [ -n "$value" ]
  eval $key='"$value"'
}

_use_zenity() {
  use_x11 && which zenity >/dev/null && return 0 || return 1
}

if _use_zenity; then
  ask() { _zenity_ask "$@"; }
  propose() { _zenity_propose "$@"; }
  secret() { _zenity_secret "$@"; }
fi
