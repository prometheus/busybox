#!/usr/bin/env bash

# Copyright 2016 The Prometheus Authors
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

[ "$#" -lt 3 ] && echo "Missing args: $0 {IMAGE_NAME} {ARCH} {SUFFIX} {VERSIONS}" && exit 2;

IMAGE_NAME="$1"; shift;
INPUT_ARCH="$1"; shift;
SUFFIX="$1"; shift;
TAG="bookworm-slim"
PLATFORM="linux/amd64"

case "${INPUT_ARCH}" in
    arm32v7)
        PLATFORM="linux/arm/v7"
        ;;
    arm64v8)
        PLATFORM="linux/arm64"
        ;;
    riscv64)
        PLATFORM="linux/riscv64"
        TAG="sid-slim"
        ;;
    ppc64le)
        PLATFORM="linux/ppc64le"
        ;;
    s390x)
        PLATFORM="linux/s390x"
        ;;
esac

# We use official images with --platform, so no prefix needed
ARCH=""

versions=( "$@" )
if [[ "${#versions[@]}" -eq 0 ]]; then
  versions=( */ )
fi
versions=( "${versions[@]%/}" )