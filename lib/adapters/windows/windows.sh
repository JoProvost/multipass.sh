#!/bin/bash

# All executables are win-executables
use_cygwin() {
  test -f /proc/version || return 1
  grep -qE "(CYGWIN_NT|Cygwin)" /proc/version && return 0 || return 1
}

# Running win-executables must be configured in binfmt_misc
# https://en.wikipedia.org/wiki/Binfmt_misc
# sudo echo ":WSLInterop:M::MZ::/init:" > /proc/sys/fs/binfmt_misc/register
use_wsl() {
  test -f /proc/version || return 1
  grep -qE "(Microsoft|WSL)" /proc/version && return 0 || return 1
}

use_windows() {
  use_cygwin || use_wsl && return 0 || return 1
}
