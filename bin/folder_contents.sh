#!/bin/bash -ex
# shellcheck disable=SC2016,SC2288

eval "$(jq -r '@sh "export code_location=\(.code_location) output_dir=\(.output_dir)"')"
echo "code_location: $code_location output_dir: $output_dir" > /tmp/output.txt

# Convert json argument into environment variables
# for s in $(echo "$@" | jq -r "to_entries|map(\"\(.key)=\(.value|tostring)\")|.[]" ); do
#     export "$s"
# done

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
MD5_OUTPUT="$(find "$code_location" -type f | xargs $MD5_PROGRAM | $MD5_PROGRAM | awk '{ print $1 }' )"

# Output result as JSON back to terraform
jq --null-input \
  --arg location "$output_dir/$MD5_OUTPUT.zip" \
  --arg hash "$MD5_OUTPUT" \
  '{"location": $location, "hash": $hash}'
