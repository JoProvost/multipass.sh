#!/bin/bash

ADB_PIPE=${ADB_PIPE:-/storage/self/primary/.adb-reader.pipe}
ADB_PIPE_READER=${ADB_PIPE_READER:-$(dirname $ADB_PIPE)/adb-reader.sh}

_use_adb() {
  [ -d $(dirname $ADB_PIPE) ] && return 0 || return 1
}

_adb_type_password() {
  echo 'input keyevent KEYCODE_APP_SWITCH; input keyevent KEYCODE_APP_SWITCH' > $ADB_PIPE
  sleep 2
  echo 'input text "'"$1"'"' > $ADB_PIPE
}

_adb_reader_install() {
  if ! [ -f $ADB_PIPE_READER ]; then
    mkdir -p $(dirname $ADB_PIPE_READER)

    cat > $ADB_PIPE_READER << ____EOF
#!/system/bin/sh
shell=$ADB_PIPE
while true
do
  while [ ! -f \$shell ]
  do
    sleep 1
  done
  sh \$shell
  rm \$shell
done </dev/null >/dev/null 2>&1 &
____EOF

    echo "Type the following on your PC at each boot:"
    echo "  adb shell $ADB_PIPE_READER"
  fi
}

if _use_adb; then
  type_password() { _adb_type_password "$@"; }
  _adb_reader_install
fi
