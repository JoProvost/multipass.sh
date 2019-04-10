#!/bin/bash

ADB_SPOOL=${ADB_SPOOL:-/storage/self/primary/.adb-spool}
ADB_SPOOLER=${ADB_SPOOLER:-$(dirname $ADB_SPOOL)/adb-spooler.sh}

ADB_COMMAND_COUNTER=0

android_shell_adb() {
  mkdir -p $ADB_SPOOL
  local c=''
  for i in "$@"; do
    i="${i//\\/\\\\}"
    c="${c:+${c} }\"${i//\"/\\\"}\""
  done
  echo "$c" > $ADB_SPOOL/$(date +%s).$(( ADB_COMMAND_COUNTER++ ))
}

android_shell_adb_spooler_install() {
  if ! [ -f $ADB_SPOOLER ]; then
    mkdir -p $(dirname $ADB_SPOOLER)

    cat > $ADB_SPOOLER << ____EOF
#!/system/bin/sh
echo \$0 is running!
echo You can safely quit ADB by doing [Ctrl] + [C] and disconnect your phone.
while true
do
  for command in ${ADB_SPOOL}/*; do
    if [ ! -f \$command ]; then
      sleep 1
    else
      sh \$command
      rm \$command
    fi
  done
done </dev/null >/dev/null 2>&1 &
____EOF

    echo "Type the following on your PC at each boot:"
    echo "  adb shell sh $ADB_SPOOLER"
  fi
}
