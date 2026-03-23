#!/bin/bash

source "$(dirname "$0")/lib/utils.sh" 

function get_instances_help() {
    echo "mockcloudctl get instances

    Lista todas as instâncias"
}

function get_instances() {
    while :; do
        case $1 in
            "--help"|"-h")
                get_instances_help
                exit 0
                ;;
            *)
                break
        esac
    done
    token=$(get_token)
    [[ "$?" -gt 0 ]] && err "Token não encontrado, favor rodar mockcloudctl login"
    curl --fail-with-body -X GET localhost:8080/instances \
        -H "Authorization: Bearer ${token}" \
        -H "Content-Type: application/json"
}

function create_instance_help() {
    echo 'mockcloudctl create instance

    Cria uma instância
    
    --instance-json           Arquivo JSON com a instância.
    
    Formato de exemplo de uma instance

    {
        "fqdn": "staging.alura.com", 
        "memory": 1024,
        "cpu": 2,
        "user_data": "echo provisioned"
    }'
    
}

function create_instance() {
    if [[ -z "$*" ]]; then
        create_instance_help
        exit 1
    fi
    while :; do
        case $1 in
            "--help"|"-h")
                create_instance_help
                exit 0
                ;;
            "--instance-json")
                if [[ -n "$2" ]]; then
                    instance_json=$2
                else
                    err "Por favor, passe um json de instance."
                fi
                shift
                shift
                ;;
            *)
                break
        esac
    done
    echo "Create instance from file $instance_json"
    token=$(get_token)
    [[ "$?" -gt 0 ]] && err "Token não encontrado, favor rodar mockcloudctl login"
    curl --fail-with-body -X POST localhost:8080/instance \
        -H "Authorization: Bearer ${token}" \
        -H "Content-Type: application/json" \
        -d @"$instance_json"
}

function delete_instance_help() {
    echo 'mockcloudctl delete instance

    Deleta uma instância
    
    --id                    ID da instância.
   '
    
}

function delete_instance() {
    if [[ -z "$*" ]]; then
        delete_instance_help
        exit 1
    fi
    while :; do
        case $1 in
            "--help"|"-h")
                delete_instance_help
                exit 0
                ;;
            "--id")
                if [[ -n "$2" ]]; then
                    id=$2
                else
                    err "Por favor, digite o id da instância a ser deletada."
                fi
                shift
                shift
                ;;
            *)
                break
        esac
    done
    token=$(get_token)
    [[ "$?" -gt 0 ]] && err "Token não encontrado, favor rodar mockcloudctl login"
    curl --fail-with-body -X DELETE "localhost:8080/instance/$id" \
        -H "Authorization: Bearer ${token}" \
        -H "Content-Type: application/json"
}

function get_instance_help() {
    echo 'mockcloudctl get instance

    Obtém uma instância
    
    --id                    ID da instância.
   '
    
}

function get_instance() {
    if [[ -z "$*" ]]; then
        get_instance_help
        exit 1
    fi
    while :; do
        case $1 in
            "--help"|"-h")
                get_instance_help
                exit 0
                ;;
            "--id")
                if [[ -n "$2" ]]; then
                    id=$2
                else
                    err "Por favor, digite o id da instância a ser obtida."
                fi
                shift
                shift
                ;;
            *)
                break
        esac
    done
    token=$(get_token)
    [[ "$?" -gt 0 ]] && err "Token não encontrado, favor rodar mockcloudctl login"
    curl --fail-with-body -X GET "localhost:8080/instance/$id" \
        -H "Authorization: Bearer ${token}" \
        -H "Content-Type: application/json"
}

function top_instance_help() {
    echo 'mockcloudctl top instance

    Exibe o status de CPU da instância.
    
    --id                    ID da instância.
   '
    
}

function top_instance() {
    if [[ -z "$*" ]]; then
        top_instance_help
        exit 1
    fi
    while :; do
        case $1 in
            "--help"|"-h")
                top_instance_help
                exit 0
                ;;
            "--id")
                if [[ -n "$2" ]]; then
                    id=$2
                else
                    err "Por favor, digite o id da instância a ser verificada."
                fi
                shift
                shift
                ;;
            *)
                break
        esac
    done
    token=$(get_token)
    [[ "$?" -gt 0 ]] && err "Token não encontrado, favor rodar mockcloudctl login"
    curl --fail-with-body -X GET "localhost:8080/instance/$id/top" \
        -H "Authorization: Bearer ${token}" \
        -H "Content-Type: application/json"
}

function log_instance_help() {
    echo 'mockcloudctl log instance

    Exibe os logs instância.
    
    --id                    ID da instância.
   '
    
}

function log_instance() {
    if [[ -z "$*" ]]; then
        log_instance_help
        exit 1
    fi
    while :; do
        case $1 in
            "--help"|"-h")
                log_instance_help
                exit 0
                ;;
            "--id")
                if [[ -n "$2" ]]; then
                    id=$2
                else
                    err "Por favor, digite o id da instância a ser logada."
                fi
                shift
                shift
                ;;
            *)
                break
        esac
    done
    token=$(get_token)
    [[ "$?" -gt 0 ]] && err "Token não encontrado, favor rodar mockcloudctl login"
    curl --fail-with-body -X GET "localhost:8080/instance/$id/logs" \
        -H "Authorization: Bearer ${token}" \
        -H "Content-Type: application/json"
}