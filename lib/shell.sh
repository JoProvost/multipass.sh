#!/bin/bash

cd $(dirname $(readlink -f ${BASH_SOURCE[0]}))
. ./operations.sh
. ./adapters.sh
for adapter in $(find adapters/ -name '*.sh'); do . ${adapter}; done
cd - >/dev/null

pass() {
  initialize "$@"

  propose site "Sélectionnez le site" "$(web_site)" <(list)
  ask site "Nom du site" "$(web_site)"
  load "$site"

  ask iterations "Nombre d'itérations" $(iterations "$site")
  ask length "Longueur" none
  ask filter "Filtre" "s/[^0-9a-zA-Z]//g"
  secret pass "Mot de passe"

  type_password "$(
    password "${site}" "${pass}" "${iterations}" \
      | filter "${filter}" "${length}"
  )"

  save "$site"
}
