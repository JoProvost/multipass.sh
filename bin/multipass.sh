#!/bin/bash

pushd $(dirname $(readlink -f $0)) >/dev/null
source ../lib/shell.sh
popd >/dev/null

set -e

[ "${BUILD_MULTIPASS_SH:-}" = "true" ] || pass "$@"
