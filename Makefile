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

REPOSITORY ?= quay.io/prometheus
NAME       := busybox
BRANCH     := $(shell git rev-parse --abbrev-ref HEAD)
SUFFIX     ?= -$(subst /,-,$(BRANCH))
VERSIONS   ?= uclibc glibc

.PHONY: all
all: build

.PHONY: build
build:
	@./build.sh "$(REPOSITORY)/$(NAME)-linux-amd64" "" "$(SUFFIX)" $(VERSIONS)
	@./build.sh "$(REPOSITORY)/$(NAME)-linux-armv7" "arm32v7" "$(SUFFIX)" $(VERSIONS)
	@./build.sh "$(REPOSITORY)/$(NAME)-linux-arm64" "arm64v8" "$(SUFFIX)" $(VERSIONS)
	# uclibc doens't support ppc64le, s390x
	@./build.sh "$(REPOSITORY)/$(NAME)-linux-ppc64le" "ppc64le" "$(SUFFIX)" glibc
	@./build.sh "$(REPOSITORY)/$(NAME)-linux-s390x" "s390x" "$(SUFFIX)" glibc

.PHONY: tag
tag:
	docker tag "$(REPOSITORY)/$(NAME)-linux-amd64:uclibc" "$(REPOSITORY)/$(NAME)-linux-amd64:latest"
	docker tag "$(REPOSITORY)/$(NAME)-linux-armv7:uclibc" "$(REPOSITORY)/$(NAME)-linux-armv7:latest"
	docker tag "$(REPOSITORY)/$(NAME)-linux-arm64:uclibc" "$(REPOSITORY)/$(NAME)-linux-arm64:latest"
	docker tag "$(REPOSITORY)/$(NAME)-linux-ppc64le:glibc" "$(REPOSITORY)/$(NAME)-linux-ppc64le:latest"
	docker tag "$(REPOSITORY)/$(NAME)-linux-s390x:glibc" "$(REPOSITORY)/$(NAME)-linux-s390x:latest"

.PHONY: manifest
manifest:
	# Manifest for "ulibc"
	DOCKER_CLI_EXPERIMENTAL=enabled docker manifest create -a "$(REPOSITORY)/$(NAME):uclibc" \
		"$(REPOSITORY)/$(NAME)-linux-amd64:uclibc" \
		"$(REPOSITORY)/$(NAME)-linux-armv7:uclibc" \
		"$(REPOSITORY)/$(NAME)-linux-arm64:uclibc"
	DOCKER_CLI_EXPERIMENTAL=enabled docker manifest push "$(REPOSITORY)/$(NAME):uclibc"

	# Manifest for "glibc"
	DOCKER_CLI_EXPERIMENTAL=enabled docker manifest create -a "$(REPOSITORY)/$(NAME):glibc" \
		"$(REPOSITORY)/$(NAME)-linux-amd64:glibc" \
		"$(REPOSITORY)/$(NAME)-linux-armv7:glibc" \
		"$(REPOSITORY)/$(NAME)-linux-arm64:glibc" \
		"$(REPOSITORY)/$(NAME)-linux-ppc64le:glibc" \
		"$(REPOSITORY)/$(NAME)-linux-s390x:glibc"
	DOCKER_CLI_EXPERIMENTAL=enabled docker manifest push "$(REPOSITORY)/$(NAME):glibc"

	# Manifest for "latest"
	DOCKER_CLI_EXPERIMENTAL=enabled docker manifest create -a "$(REPOSITORY)/$(NAME):latest" \
		"$(REPOSITORY)/$(NAME)-linux-amd64:latest" \
		"$(REPOSITORY)/$(NAME)-linux-armv7:latest" \
		"$(REPOSITORY)/$(NAME)-linux-arm64:latest" \
		"$(REPOSITORY)/$(NAME)-linux-ppc64le:latest" \
		"$(REPOSITORY)/$(NAME)-linux-s390x:latest"
	DOCKER_CLI_EXPERIMENTAL=enabled docker manifest push "$(REPOSITORY)/$(NAME):latest"

.PHONY: push
push:
	@./push.sh "$(REPOSITORY)/$(NAME)-linux-amd64" "" "$(SUFFIX)" $(VERSIONS)
	@./push.sh "$(REPOSITORY)/$(NAME)-linux-armv7" "arm32v7" "$(SUFFIX)" $(VERSIONS)
	@./push.sh "$(REPOSITORY)/$(NAME)-linux-arm64" "arm64v8" "$(SUFFIX)" $(VERSIONS)
	# uclibc doens't support ppc64le, s390x
	@./push.sh "$(REPOSITORY)/$(NAME)-linux-ppc64le" "ppc64le" "$(SUFFIX)" glibc
	@./push.sh "$(REPOSITORY)/$(NAME)-linux-s390x" "s390x" "$(SUFFIX)" glibc
