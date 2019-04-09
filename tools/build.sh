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

build() {
  output=${2:-build/$(basename $1)}
  mkdir -p $(dirname $output)
  output=$(readlink -f ${output})
  rm -f ${output}.deps
  echo "#!/bin/bash" > $output
  echo "readonly BUILD_MULTIPASS_SH=false" >> $output

  set -- "$1"
  source $1
  rm -f ${output}.deps
}

source_all() {
  for adapter in "${@}"; do source ${adapter}; done
}

source() {
  BUILD_MULTIPASS_SH=true
  touch ${output}.deps
  source_file="$(readlink -f $1)"
  if ! grep -Fxq "${source_file}" "${output}.deps"; then
    echo ${source_file} >> "${output}.deps"
    ( . $1 )
    echo "" >> $output
    echo "# source $1" >> $output
    grep -v '^source ' "$1" | grep -v '^source_all ' | grep -v '^cd' | grep -v '^#!\/bin\/bash'>> $output
  fi
}

build "${@}"
