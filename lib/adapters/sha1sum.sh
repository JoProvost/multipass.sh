#!/bin/bash

_sha1sum_sha1() {
  sha1sum | cut -d ' ' -f 1 | sed 's/\([0-9A-F]\{2\}\)/\\\\\\x\1/gI' | xargs printf
}

_use_sha1sum() {
  for tool in sha1sum cut sed xargs printf; do
    which $tool >/dev/null || return 1
  done
  return 0
}

if _use_sha1sum; then
  sha1() { _sha1sum_sha1; }
fi
