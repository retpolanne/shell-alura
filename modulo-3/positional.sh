#!/bin/bash

# Vamos receber os argumentos posicionais

# Lista quandos argumentos posicionais foram passados
echo $#

# Expande cada argumento como strings separadas
echo $@

# O $0 é sempre o nome do script
echo $0 
echo $1
echo $2
# ...

# Podemos guardar o que vem do $@ em variáveis separadas
read -r name surname <<< "$@"

echo "Hello $surname, $name"