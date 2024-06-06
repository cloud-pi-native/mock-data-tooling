#!/bin/bash

# Script permettant de chiffrer des manifest kubernetes via SOPS
# Le script parcourt le dossier courant et sous-dossiers pour trouver des fichiers avec l'extension .dec
# Les fichiers chiffrés sont sauvegardés avec l'extension .enc au lieu de .dec
# Il est obligatoire de fournir les arguments suivants: environnement et phase
# test/
#   encrypt.sh
#   ovh/
#     dev/
#        secrets.yml.dec
#        other_secrets.yml.dec
#   mi/
#     pprod/
#        secrets.yml.dec
#
# bash encrypt.sh ovh dev => ovh/dev/secrets.yml.dec , ovh/dev/other_secrets.yml.dec , mi/pprod/secrets.yml.dec
# bash encrypt.sh mi pprod => mi/pprod/secrets.yml.dec
#

AGE_KEY_OVH_DEV=age1g867s7tcftkgkdraz3ezs8xk5c39x6l4thhekhp9s63qxz0m7cgs5kan9a
AGE_KEY_MI_INTEG=age1lxduvqtglrdj38m27gsa4akdu82keqwgh7r57ep3dcwf7uaref4qtafwy5
AGE_KEY_MI_PROD=age190waxlxyv9l0s5ec8600u7ujknrugffz6fjxde8tndy9gw68rckstws8dp

encrypt_path="$1/$2"

declare -A keys=[]
keys["ovh:dev"]=${AGE_KEY_OVH_DEV}
keys["mi:integ"]=${AGE_KEY_MI_INTEG}
keys["mi:prod"]=${AGE_KEY_MI_PROD}

if [ $# -gt 0 ]; then
  if [ ! -d "$1" ]; then
    echo "Chemin non existant"
    exit 1
  fi
fi

current_key=${keys[$1:$2]}

for current_file in $(find ${encrypt_path} -name *.dec)
do
  filename="${current_file%.*}"
  extension="${current_file##*.}"

  if [ $extension == "dec" ]; then
    encrypted_file_path="${filename}.enc"
    echo "Encrypt file ${current_file} to ${encrypted_file_path}"
    sops -e --age $current_key --input-type yaml --output-type yaml --encrypted-suffix Templates "${current_file}" > "${encrypted_file_path}"
  fi
done
