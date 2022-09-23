#!/bin/bash -e

eval "$(jq -r '@sh "OUTPUT_DIR=\(.output_dir) CODE_LOCATION=\(.code_location)"')"

dotnet lambda package \
  -o "$OUTPUT_DIR/bundle.zip" \
  -pl "$CODE_LOCATION" \
  1>&2

HASH="$(sha256sum "$OUTPUT_DIR/bundle.zip" | cut -d ' ' -f 1)"

mv "$OUTPUT_DIR/bundle.zip" "$OUTPUT_DIR/$HASH.zip"

jq --null-input \
  --arg location "$OUTPUT_DIR/$HASH.zip" \
  --arg hash "$HASH" \
  '{"location": $location, "hash": $hash}'
