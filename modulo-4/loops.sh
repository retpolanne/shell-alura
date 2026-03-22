#!/bin/bash
# No mac, executar como bash loops.sh
echo {1..100}
for i in {1..10}; do
    echo "$i"
done

echo "for, c style"
for (( i=0; i<5; i++ )); do
    echo "$i"
done

echo "For loop"
# Use globbing aqui ao invés de ls /dev/ttys
for file in /dev/ttys{1..4}; do
    echo "$file"
done

echo "While loop"
find /dev/ttys{1..4} | while read -r file; do
    echo "$file"
done

echo "while, c style"
i=0
while (( i<10 )); do
    if [[ "$i" == 2 ]]; then
        i=$((i + 1))
        continue
    fi
    echo $i
    i=$((i + 1))
done

echo "Array"
crossing=("Tom" "Isabelle" "Timmy")
echo "${crossing[0]}"
i=1
echo "${crossing[i]}"
# Arrays são contextos matemáticos
echo "${crossing[i+1]}"
echo "${crossing[@]}"
# As expansões de string funcionam também para arrays
echo "${crossing[@]/%/ aaaa}"

for char in "${crossing[@]}"; do
    echo "${char}"
done

# Arrays associativas
declare -A CROSSING=(
    [Isabelle]="Dog"
    [Tim]="Nook"
    [Timmy]="Nook"
)
# Pegando todas as keys
echo "${!CROSSING[@]}"

# Acessando uma chave
echo "${CROSSING[Isabelle]}"