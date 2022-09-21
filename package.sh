#!/bin/bash -e

eval "$(jq -r '@sh "OUTPUT_DIR=\(.output_dir) CODE_LOCATION=\(.code_location)"')"

dotnet lambda package \
  -o "$OUTPUT_DIR" \
  -pl "$CODE_LOCATION" \
  1>&2

HASH="$(sha256sum "$OUTPUT_DIR" | cut -d ' ' -f 1)"

jq --null-input \
  --arg location "$OUTPUT_DIR" \
  --arg hash "$HASH" \
  '{"location": $location, "hash": $hash}'
