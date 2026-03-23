#!/bin/bash

temp=$(mktemp)
cat verbs.txt | while read -r verb; do
    echo '{"username": "dummy", "verb": "'$verb'", "action": "ALLOW"}' > "$temp"
    ./mockcloudctl create policy --policy-json "$temp"
done
rm "$temp"