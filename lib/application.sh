#!/bin/bash

if [ -f functions.sh ]; then
  . functions.sh
fi

if [ -f adapters.sh ]; then
  . adapters.sh
fi

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
