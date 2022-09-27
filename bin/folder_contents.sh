#!/bin/bash -e

# List of arguments
eval "$(jq -r '@sh "OUTPUT_DIR=\(.output_dir) CODE_LOCATION=\(.code_location)"')"

# Linux has command md5sum and OSX has command md5
if command -v md5sum >/dev/null 2>&1; then
  MD5_PROGRAM=md5sum
elif command -v md5 >/dev/null 2>&1; then
  MD5_PROGRAM=md5
else
  echo "ERROR: md5sum is not installed"
  exit 255
fi

# Take md5 from each object inside the program and then take a md5 of that output
MD5_OUTPUT="$(eval $MD5_PROGRAM "$CODE_LOCATION/**" | $MD5_PROGRAM )"

# Output result as JSON back to terraform
jq --null-input \
  --arg location "$OUTPUT_DIR/$MD5_OUTPUT.zip" \
  --arg hash "$MD5_OUTPUT" \
  --arg
  '{"location": $location, "hash": $hash}'
