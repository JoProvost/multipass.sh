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
    display dialog "$text" default answer "$default" with icon stop buttons {"Cancel", "Continue"} default button "Continue"
EOF
)"
    [ -n "$value" ]
    eval $key='"$value"'
  fi
}

_applescript_secret() {
  local key="${1:-}"
  local text="${2:-}"

    local value="$( osascript <<EOF | sed 's#.*text returned:##g'
    display dialog "$text" with icon stop buttons {"Cancel", "Continue"} default button "Continue" with hidden answer
EOF
)"
  [ -n "$value" ]
  eval $key='"$value"'
}

if _use_applescript; then
  type_password() { _applescript_type_password "$@"; }
  input() { _applescript_input "$@"; }
  secret() { _applescript_secret "$@"; }
fi
