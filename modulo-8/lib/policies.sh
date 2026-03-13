#!/bin/bash

function list_policies_help() {
    echo "mockcloudctl list policies

    Lista todas as policies."
}

function list_policies() {
    local flags="${1}"
    for flag in "${flags[@]}"; do
        if [[ "${flag}" == "--help" || "${flag}" == "-h" ]]; then
            list_policies_help
            exit
        fi
    done
    echo "List policies"
}