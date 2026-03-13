# Módulo 4

## Emulando um grep recursivo com o find

É possível executar comandos usando o output do find. 

```sh
find . -type d \
    -name ".git" \
    -prune \
    -or -type f \
    -name "*" \
    -exec grep "Neko" {} \;
```

Também é possível usar o xargs

```sh
find . -type d \
    -name ".git" \
    -prune \
    -or -type f \
    -name "*" | xargs -I {} grep "Neko" {}
```

## Gerando relatórios usando o top

Esse comando só funciona no GNU top, então use uma máquina virtual
caso você esteja no Mac. 

```sh
top -b -n4
```