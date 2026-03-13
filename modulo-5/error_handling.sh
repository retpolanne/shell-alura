#!/bin/bash

name=$1

if [[ "${name}" == "Neko" ]]; then
    echo "Forbidden name!" >&2
    exit 123
fi

temp=$(mktemp --suffix .log)
trap "{ echo 'cleaning ${temp}'; rm ${temp}; }" SIGINT SIGTERM

sleep 1000