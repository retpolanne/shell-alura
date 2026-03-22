#!/bin/bash

# Exemplo adaptado de https://www.gnu.org/software/parallel/parallel_examples.html

TEMPDIR=$(mktemp -d)
curl -s "https://images-api.nasa.gov/search?q=apollo11&media_type=image" | \
    jq -r '.collection.items[].href' | \
    parallel curl -s | \
    jq -r '.[]' | \
    grep ".*.jpg" | \
    parallel wget -P "$TEMPDIR"
echo "Images saved to $TEMPDIR"