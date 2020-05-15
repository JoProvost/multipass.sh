#!/bin/bash

_applescript_type_password() {
  osascript -e "tell application \"System Events\"
keystroke \"$1\"
end tell"
}

_use_applescript() {
  which osascript >/dev/null && return 0 || return 1
}

_applescript_input() {
  local key="${1:-}"
  local text="${2:-}"
  local default="${3:-}"

  if ! [ "${!key:-}" ]; then
    local value="$( osascript <<EOF | sed 's#.*text returned:##g'
    Tell application "System Events" to display dialog "$text" with title "$TITLE" default answer "$default"
EOF
)"
    [ -n "$value" ]
    eval $key='"$value"'
  fi
}

_applescript_secret() {
  local key="${1:-}"
  local text="${2:-}"

  local value="$(
    osascript -e 'Tell application "System Events" to display dialog "'"$text"'" with title "'"$TITLE"'" with hidden answer default answer ""' \
              -e 'text returned of result' 2>/dev/null
  )"
  [ -n "$value" ]
  eval $key='"$value"'
}

_applescript_question() {
  local key="${1}"
  local text="${2:-}"
  local yes="${3:-true}"
  local no="${4:-false}"

  if ! [ "${!key:-}" ]; then
    local value="$(
    osascript \
      -e 'Tell application "System Events" to display dialog "'"$text"'" with title "'"$TITLE"'" buttons {"Oui", "Non"} default button "Non"' \
      -e 'button returned of result' 2>/dev/null
    )"
    [ -n "$value" ]
    case $value in
      Oui) eval $key='"'"$yes"'"' ;;
      Non) eval $key='"'"$no"'"' ;;
    esac
  fi
}

load_applescript() {
  if _use_applescript; then
    type_password() { _applescript_type_password "$@"; }
    input() { _applescript_input "$@"; }
    question() { _applescript_question "$@"; }
    secret() { _applescript_secret "$@"; }
  fi
}

[ "${BUILD_MULTIPASS_SH:-}" = "true" ] || load_applescript
