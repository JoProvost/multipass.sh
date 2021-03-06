#!/bin/bash
if [ -f ~/.multipass.sh/.env ]
then
    . ~/.multipass.sh/.env
fi

[ "${BUILD_MULTIPASS_SH:-}" = "true" ] || cat <<"BANNER"
                      _  _    _                                  _
    _ __ ___   _   _ | || |_ (_) _ __    __ _  ___  ___     ___ | |__
   | '_ ` _ \ | | | || || __|| || '_ \  / _` |/ __|/ __|   / __|| '_ \
   | | | | | || |_| || || |_ | || |_) || (_| |\__ \\__ \ _ \__ \| | | |
   |_| |_| |_| \__,_||_| \__||_|| .__/  \__,_||___/|___/(_)|___/|_| |_|
                                |_|
BANNER

pushd $(dirname $(readlink -f $0)) >/dev/null
source ../lib/shell.sh
popd >/dev/null

set -e

[ "${BUILD_MULTIPASS_SH:-}" = "true" ] || pass "$@"
