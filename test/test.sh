#!/bin/bash

readlink=$(which readlink)
readlink() {
  if [ "$1" = "-f" ]; then
    # Reference: https://gist.github.com/esycat/5279354#file-readlink-sh
    local TARGET=$2

    cd $(dirname "$TARGET")
    TARGET=$(basename "$TARGET")

    # Iterate down a (possible) chain of symlinks
    while [ -L "$TARGET" ]
    do
      TARGET=$($readlink "$TARGET")
      cd $(dirname "$TARGET")
      TARGET=$(basename "$TARGET")
    done

    # Compute the canonicalized name by finding the physical path
    # for the directory we're in and appending the target file.
    local DIR=`pwd -P`
    local RESULT="$DIR/$TARGET"

    echo $RESULT
  else
    $readlink "${@}"
  fi
}

errors=0
for suite in $(find $(dirname $0) -name '*_test.sh'); do
  $suite
  errors=$(( errors + $? ))
done
exit $errors
