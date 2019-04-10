#!/bin/bash

pushd $(dirname $(readlink -f ${BASH_SOURCE[0]})) >/dev/null
source ./x11.sh
popd >/dev/null

_zenity_input() {
  local key="${1:-}"
  local text="${2:-}"
  local default="${3:-}"

  if ! [ "${!key:-}" ]; then
    local value="$( zenity --entry --title="$TITLE" --text="$text" ${3+--entry-text=${default:-}} )"
    [ -n "$value" ]
    eval $key='"$value"'
  fi
}

_zenity_question() {
  local key="${1}"
  local text="${2:-}"
  local yes="${3:-true}"
  local no="${4:-false}"

  if ! [ "${!key:-}" ]; then
    zenity --question --title="$TITLE" --text="$text" && eval $key='"${yes}"' || eval $key='"${no}"'
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

load_zenity() {
  if _use_zenity; then
    input() { _zenity_input "$@"; }
    question() { _zenity_question "$@"; }
    propose() { _zenity_propose "$@"; }
    secret() { _zenity_secret "$@"; }
  fi
}

[ "${BUILD_MULTIPASS_SH:-}" = "true" ] || load_zenity
