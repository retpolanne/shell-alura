#!/bin/bash

show_help() {
  echo "$(basename "$0") [OPTIONS] -- exibe o nome do personagem
  
  [OPTIONS]
    -h      Mostra essa mensagem
    -n      Nome do personagem
  "
}
if [[ -z "$1" ]]; then
  show_help
  exit
fi

# O getopts usa a variável OPTIND como indicador da variável
# sendo parseada.
# Se você usou o getopts uma vez anteriormente no script, 
# reinicie o valor do OPTIND. 
OPTIND=1

# getopts é um programa a parte. 
# ele tem como sintaxe:
# getopts optstring variável

# O : indica que a variável vai receber algum valor
while getopts hn: opt; do
  case $opt in
    h)
      show_help
      exit 0
      # O ;; para a execução do case no caso específico,
      # para não continuar parseando os próximos casos
      # na mesma execução.
      ;;
    n)
      # O valor é definido no $OPTARG
      name=$OPTARG
      ;;
    *)
      show_help
      exit 1
      ;;
  esac
done

echo "Hello $name"