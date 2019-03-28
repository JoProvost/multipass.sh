#!/bin/bash

_base64_encode() {
  base64
}

_base64_decode() {
  base64 -d
}
_use_base64() {
  which base64 >/dev/null && return 0 || return 1
}

if _use_base64; then
  encode() { _base64_encode; }
  decode() { _base64_decode; }
fi
