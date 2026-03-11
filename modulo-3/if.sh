#!/bin/bash

# Vamos receber o nome como argumento de linha de comando
name=$1
age=$2

# Uma estrutura if, elif, else muito simples

# Sempre manter o then na mesma linha que o if
# Para comparar, use sempre == ao invés de =
if [[ "${name}" == "Neko" ]]; then
  echo "Neko Coneco"
elif [[ "${name}" == "Nook" ]]; then
  echo "Tom Nook"
elif [[ -z "${name}" ]]; then
  # Se a variável ${name} estiver vazia, cai aqui
  echo "Mysterious..."
elif [[ -n "${name}" ]]; then
  # Se a variável tiver algo, cai aqui
  echo "You have a name but I don't know you!"
else
  echo "You have no name!"
fi

# E para fazer comparações aritméticas
# Aritmética com (( )), não use aspas aqui
if (( age > 18 )); then
  echo "You are an adult!"
# Caso você queira usar [[ ]], use aspas!
elif [[ "${age}" -lt 10 ]]; then
  echo "You are still a kid, not even a teenager!"
fi
