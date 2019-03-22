#!/bin/bash

_openssl_encode() {
  openssl base64
}

_openssl_decode() {
  openssl base64 -d
}

_openssl_hash() {
  echo "${1}" | decode | openssl dgst -binary -sha1 | encode
}

_use_openssl() {
  which openssl >/dev/null && return 0 || return 1
}

if _use_openssl; then
  encode() { _openssl_encode "$@"; }
  decode() { _openssl_decode "$@"; }
  hash() { _openssl_hash "$@"; }
fi
