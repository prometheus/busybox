#!/usr/bin/env bash

[ "$#" -eq 0 ] && echo "Missing args: $0 {IMAGE_NAME} {SUFFIX} {VERSIONS}";

IMAGE_NAME="$1"; shift;
SUFFIX="$1"; shift;

versions=( "$@" )
if [ ${#versions[@]} -eq 0 ]; then
  versions=( */ )
fi
versions=( "${versions[@]%/}" )
