#!/bin/bash
# ^ isso aqui se chama shebang. 
# É sempre útil usar comentários para explicar o que um 
# script faz. 
# Não esqueça de evitar escrever linhas muito longas!

# Tenha configurado no VSCode (ou o editor que você utilizar)
# e no seu terminal o programa "shellcheck". 
# Ele vai apontar lugares onde você deveria melhorar!

# Para uma referência rápida, confira https://google.github.io/styleguide/shellguide.html

# Indentar com 2 espaços. 

# Declarando uma variável readonly global
readonly NAME="Neco Coneco"
export NAME

# Lendo outro arquivo .sh com funções, biblioteca, etc. 
source miau.sh

# É recomendado ter uma função de erro pra mandar logs de erro pro STDERR. 
err() {
  # Aqui a gente printa o timestamp e redireciona pro STDERR.
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

function meow_meow() {
  counter=$1
  echo "Meow! $counter"
}

# Use \ para quebrar linhas e pipelines
find /usr/share/man \
  | head -100 \
  | xargs man 2>/dev/null

# do e then na mesma linha que for, while, if...
for miau_counter in {1..100}; do
  meow_meow "$miau_counter"
done

if [[ "${NAME}" == "Neco*" ]]; then
  echo "${NAME}"
  # Essa função vem de outro arquivo.
  hello_everynyan
fi
