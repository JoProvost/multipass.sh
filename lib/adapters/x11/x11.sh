#!/bin/bash

use_x11() {
  [ -n "${DISPLAY:-}" ] && return 0 || return 1
}
