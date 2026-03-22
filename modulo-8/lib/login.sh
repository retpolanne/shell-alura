#!/bin/bash

function login_help() {
    echo "mockcloudctl login

    Faz o login e salva o token em $HOME/.config/mockcloudctl/token
    
    --username          Nome de usuário
    
    A senha será coletada no stdin."
}

function login() {
    if [[ -z "$*" ]]; then
        login_help
        exit 1
    fi
    while :; do
        case $1 in
            "--help"|"-h")
                login_help
                exit 0
                ;;
            "--username")
                if [[ -n "$2" ]]; then
                    user=$2
                    echo "Por favor, digite a senha do usuário $user"
                    read password
                else
                    echo "Por favor, passe um nome de usuário" >&2
                    exit 1
                fi
                shift
                shift
                ;;
            *)
                break
        esac
    done
}