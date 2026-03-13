#!/bin/bash

top -b -n2 > /tmp/report
cat /tmp/report | tail -n+5 | head
cat /tmp/report | tail -n+5 | awk '$2 == "root" {print $1 " " $9 " " $12}' 

cat /tmp/report \
    | tail -n+5 \
    | awk '$2 == "root" {print $1 " " $9 " " $12}'\
    | while read -r line; do
    read -r pid cpu process <<< "$line"
    echo "The pid $pid with process $process is using $cpu% of cpu"
done

process_to_filter=(sshd nginx agetty)

for process_name in "${process_to_filter[@]}"; do
    read -r pid cpu process  < <(
        grep "${process_name}" /tmp/report \
        | awk '$2 == "root" {print $1 " " $9 " " $12}'
    )
    echo "The pid $pid with process $process is using $cpu% of cpu"
done