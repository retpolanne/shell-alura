#!/bin/bash

function get_token() {
    cat "$HOME/.config/mockcloudctl/token" 2>/dev/null
}

function create_token() {
    mkdir -p "$HOME/.config/mockcloudctl/" || true
    echo $1 > "$HOME/.config/mockcloudctl/token"
}

function err() {
    echo "<11>$(date) $(hostname) mockcloudctl: $*"
    exit 1
}