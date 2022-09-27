#!/bin/bash -e

OUTPUT_FILE="$1"
CODE_LOCATION="$2"
ARCHITECTURE="$3"

dotnet lambda package \
  -o "$OUTPUT_FILE" \
  -pl "$CODE_LOCATION" \
  -farch "$ARCHITECTURE"
