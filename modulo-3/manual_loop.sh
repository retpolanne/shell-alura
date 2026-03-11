#!/bin/bash

show_help() {
  echo "$(basename "$0") [OPTIONS] -- exibe o nome do personagem
  
  [OPTIONS]
    -h|--help      Mostra essa mensagem
    --name         Nome do personagem
  "
}
if [[ -z "$1" ]]; then
  show_help
  exit
fi
# Isso aqui é um loop infinito.
# O sinal de : é o mesmo que true.
while :; do
  case $1 in
    -h|--help)
      show_help
      exit
      ;;
    --name)
      if [[ -n "$2" ]]; then
        name="$2"
        # O shift pega o argumento que estava em $2 e
        # coloca ele em $1, e o $3 em $2, e assim vai...
        shift
      else
        # Vamos mandar o log para o stderr.
        echo "Precisa passar um nome!!" >&2
        exit 1
      fi
      ;;
    *)
      break
  # esac é case ao contrário :P
  esac
done

echo "Hello $name"