#!/bin/bash

_base64_encode() {
  base64
}

_base64_decode() {
  ( base64 -d || base64 -D ) 2>/dev/null
}
_use_base64() {
  which base64 >/dev/null && return 0 || return 1
}

load_base64() {
  if _use_base64; then
    encode() { _base64_encode; }
    decode() { _base64_decode; }
  fi
}

[ "${BUILD_MULTIPASS_SH:-}" = "true" ] || load_base64
