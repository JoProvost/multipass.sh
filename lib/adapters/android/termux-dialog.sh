#!/bin/bash

_termux_dialog_input() {
  local key="${1}"
  local text="${2:-}"
  local default="${3:-}"

  if ! [ "${!key:-}" ]; then
    local result=$(termux-dialog text -t "${text}" -i "${default}")
    local result_code="$(echo "${result}" | jq -r .code)"
    local result_text="$(echo "${result}" | jq -r .text)"
    local result_text="${result_text:-${default}}"

    [ "${result_code}" != "-2" ] || return 1
    [ -n "${result_text}" ] || return 1

    eval ${key}='"${result_text}"'
  fi
}

_termux_dialog_secret() {
  local key="${1}"
  local text="${2:-}"

  local result=$(termux-dialog text -p -t "${text}")
  local result_code="$(echo "${result}" | jq -r .code)"
  local result_text="$(echo "${result}" | jq -r .text)"

  [ "${result_code}" != "-2" ] || return 1
  [ -n "${result_text}" ] || return 1

  eval ${key}='"${result_text}"'
}

_termux_dialog_question() {
  local key="${1}"
  local text="${2:-}"
  local yes="${3:-true}"
  local no="${4:-false}"

  if ! [ "${!key:-}" ]; then
    local result=$(termux-dialog confirm -t "${text}")
    local result_code="$(echo "${result}" | jq -r .code)"
    local result_text="$(echo "${result}" | jq -r .text)"

    [ "${result_code}" != "-2" ] || return 1

    case "${result_text}" in
      'yes') eval $1='"${yes}"' ;;
      'no')  eval $1='"${no}"' ;;
    esac
  fi
}

_use_termux_dialog() {
  which termux-dialog >/dev/null && return 0 || return 1
}

load_termux_dialog() {
  if _use_termux_dialog; then
    input() { _termux_dialog_input "$@"; }
    secret() { _termux_dialog_secret "$@"; }
    question() { _termux_dialog_question "$@"; }
  fi
}

[ "${BUILD_MULTIPASS_SH:-}" = "true" ] || load_termux_dialog
