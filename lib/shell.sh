#!/bin/bash

readonly TITLE="multipass.sh"

cd $(dirname $(readlink -f ${BASH_SOURCE[0]}))
source ./operations.sh
source ./adapters.sh
source_all $(find adapters/ -name '*.sh')
cd - >/dev/null

pass() {
  initialize "$@"

  propose site "Sélectionnez le site" "$(suggested_site)" <(list)
  input site "Nom du site" "$(suggested_site)"
  load "$site"

  input iterations "Nombre d'itérations" $(iterations "$site")
  input length "Longueur" none
  input filter "Filtre" "s/[^0-9a-zA-Z]//g"
  question salt "Voulez-vous ajouter un 'salage' au mot de passe?" "$(salt)" "none"

  secret pass "Mot de passe"

  type_password "$(
    password "${site}" "${pass}" "${salt}" "${iterations}" \
      | filter "${filter}" "${length}"
  )"

  save "$site"
}
