#!/bin/bash

global_var="Nyaaaa"
function hello_everynyan() {
    echo "$@"
    read -r name surname <<< "$@"
    echo $1
    echo $2
    echo "Hello ${name} ${surname}"
    local local_var
    local_var="OhMyGah!"
    echo "${local_var}"
    echo "Before change ${global_var}"
    global_var="nyooooo"
    echo "After change ${global_var}"
}

hello_everynyan "Neco" "Coneco"
echo "Variável alterada globalmente ${global_var}"
echo "Acessando variável local ${local_var}"