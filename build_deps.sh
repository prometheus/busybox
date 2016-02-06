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

set -e

source vars.sh

for version in "${versions[@]}"; do
  docker build -t "${IMAGE_NAME}:${version}${SUFFIX}-builder" --pull -f "${version}/Dockerfile.builder" ${version}
  docker run --rm "${IMAGE_NAME}:${version}${SUFFIX}-builder" tar cC rootfs . | xz -z9 > "${version}/rootfs.tar.xz"
done
