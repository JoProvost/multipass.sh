#!/bin/bash

cd $(dirname $(readlink -f $0))
source ../lib/shell.sh
cd - >/dev/null

set -e

[ "${BUILD_MULTIPASS_SH:-}" = "true" ] || pass "$@"
