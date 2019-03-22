#!/bin/bash

ADB_PIPE=${ADB_PIPE:-/storage/self/primary/.adb-reader.pipe}
ADB_PIPE_READER=${ADB_PIPE_READER:-$(dirname $ADB_PIPE)/adb-reader.sh}

adb_shell() {
  mkdir -p $ADB_PIPE
  local command=''
  for i in "$@"; do
    i="${i//\\/\\\\}"
    command="$command \"${i//\"/\\\"}\""
  done
  echo "$command" > $ADB_PIPE/$(date +%s)-$(uuidgen -t)
}

_adb_shell_reader_install() {
  if ! [ -f $ADB_PIPE_READER ]; then
    mkdir -p $(dirname $ADB_PIPE_READER)

    cat > $ADB_PIPE_READER << ____EOF
#!/system/bin/sh
while true
do
  for f in $ADB_PIPE/*; do
    if [ ! -f \$f ]; then
      sleep 1
    else
      sh \$f
      rm \$f
    fi
  done
done </dev/null >/dev/null 2>&1 &
____EOF

    echo "Type the following on your PC at each boot:"
    echo "  adb shell $ADB_PIPE_READER"
  fi
}

use_adb_shell() {
  [ -d $(dirname $ADB_PIPE) ] && return 0 || return 1
}

if use_adb_shell; then
  _adb_shell_reader_install
fi
