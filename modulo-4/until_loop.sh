#!/bin/bash

until netcat -v -z localhost 8080; do
    echo "Can't connect to netcat"
    sleep 10
done
echo "Connected to netcat!"