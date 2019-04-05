#!/bin/bash

readonly TITLE="multipass.sh"

cd $(dirname $(readlink -f $0))
. ../lib/shell.sh
cd - >/dev/null

set -e

pass "$@"
