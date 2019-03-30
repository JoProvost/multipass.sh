#!/bin/bash

readonly TITLE="Mot de passe"

cd $(dirname $(readlink -f $0))
. ../lib/shell.sh
cd - >/dev/null

set -e

pass "$@"
