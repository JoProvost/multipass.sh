#!/bin/bash

_openssl_encode() {
  openssl base64
}

_openssl_decode() {
  openssl base64 -d
}

_openssl_sha1() {
  openssl dgst -binary -sha1
}

_use_openssl() {
  which openssl >/dev/null && return 0 || return 1
}

if _use_openssl; then
  encode() { _openssl_encode "$@"; }
  decode() { _openssl_decode "$@"; }
  sha1() { _openssl_sha1 "$@"; }
fi
