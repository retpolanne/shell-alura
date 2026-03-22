#!/bin/bash

function list_policies_help() {
    echo "mockcloudctl list policies

    Lista todas as policies."
}

function list_policies() {
    while :; do
        case $1 in
            "--help"|"-h")
                list_policies_help
                exit 0
                ;;
            *)
                break
        esac
    done
    echo "List policies"
}

function create_policy_help() {
    echo 'mockcloudctl create policy

    Cria uma policy
    
    --policy-json           Arquivo JSON com a policy.
    
    Formato de exemplo de uma policy
    
    {"username": "dummy", "verb": "getPolicies", "action": "ALLOW"}
    
    A lista de verbos está em verbs.txt'
    
}

function create_policy() {
    if [[ -z "$*" ]]; then
        create_policy_help
        exit 1
    fi
    while :; do
        case $1 in
            "--help"|"-h")
                create_policy_help
                exit 0
                ;;
            "--policy-json")
                if [[ -n "$2" ]]; then
                    policy_json=$2
                else
                    echo "Por favor, passe um json de policy." >&2
                    exit 1
                fi
                shift
                shift
                ;;
            *)
                break
        esac
    done
    echo "Create Policy from file $policy_json"
}

function update_policy_help() {
    echo 'mockcloudctl update policy

    Atualiza uma policy
    
    --id                    ID da policy.
    --policy-json           Arquivo JSON com a policy.
    
    Formato de exemplo de uma policy
    
    {"username": "dummy", "verb": "getPolicies", "action": "ALLOW"}
    
    A lista de verbos está em verbs.txt'
    
}

function update_policy() {
    if [[ -z "$*" ]]; then
        update_policy_help
        exit 1
    fi
    while :; do
        case $1 in
            "--help"|"-h")
                update_policy_help
                exit 0
                ;;
            "--id")
                if [[ -n "$2" ]]; then
                    id=$2
                else
                    echo "Por favor, digite o id da policy a ser atualizada." >&2
                    exit 1
                fi
                shift
                shift
                ;;
            "--policy-json")
                if [[ -n "$2" ]]; then
                    policy_json=$2
                else
                    echo "Por favor, passe um json de policy." >&2
                    exit 1
                fi
                shift
                shift
                ;;
            *)
                break
        esac
    done
    if [[ -z "$policy_json" || -z "$id" ]]; then
        echo "Está faltando o json da policy ou o id"
        exit 1
    fi
    echo "Update Policy from file $policy_json id $id"
}

function delete_policy_help() {
    echo 'mockcloudctl delete policy

    Deleta uma policy
    
    --id                    ID da policy.
   '
    
}

function delete_policy() {
    if [[ -z "$*" ]]; then
        delete_policy_help
        exit 1
    fi
    while :; do
        case $1 in
            "--help"|"-h")
                delete_policy_help
                exit 0
                ;;
            "--id")
                if [[ -n "$2" ]]; then
                    id=$2
                else
                    echo "Por favor, digite o id da policy a ser deletada." >&2
                    exit 1
                fi
                shift
                shift
                ;;
            *)
                break
        esac
    done
    echo "delete Policy from file $policy_json id $id"
}