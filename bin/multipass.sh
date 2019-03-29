#!/bin/bash

readonly TITLE="Mot de passe"

cd $(dirname $(readlink -f $0))

. ../lib/adapters.sh
. ../lib/functions.sh
. ../lib/application.sh

. ../lib/adapters/android/adb-shell.sh
. ../lib/adapters/android/adb-shell-input.sh
. ../lib/adapters/android/termux-dialog.sh
. ../lib/adapters/base64.sh
. ../lib/adapters/browsers/firefox.sh
. ../lib/adapters/openssl.sh
. ../lib/adapters/sha1sum.sh
. ../lib/adapters/vault.sh
. ../lib/adapters/x11/xdotool.sh
. ../lib/adapters/x11/zenity.sh

set -e

pass "$@"
