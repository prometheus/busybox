ARG ARCH=""
ARG TAG="trixie-slim"
FROM ${ARCH}debian:${TAG}
ENV DEBIAN_FRONTEND=noninteractive

RUN \
    apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates \
      gcc \
      netbase \
    && rm -rf /var/lib/apt/lists/*

RUN set -x \
    && mkdir -p rootfs/lib \
    && set -- \
        /etc/nsswitch.conf \
        /etc/ssl/certs/ca-certificates.crt \
        /usr/share/zoneinfo \
        /etc/services \
    && while [ "$#" -gt 0  ]; do \
        f="$1"; shift; \
        fn="$(basename "$f")"; \
        if [ -e "rootfs/lib/$fn" ]; then continue; fi; \
        if [ "${f#/lib/}" != "$f" ]; then \
            ln -vL "$f" "rootfs/lib/$fn"; \
        else \
            d="$(dirname $f)" \
            && mkdir -p "rootfs/${d#/}" \
            && cp -av "$f" "rootfs/${f#/}"; \
        fi; \
    done

ARG CODENAME="bookworm"
ARG VERSION="12"
ARG OS_RELEASE_FILE=/rootfs/usr/lib/os-release

RUN mkdir -p /rootfs/usr/lib && \
    echo 'PRETTY_NAME="Prometheus Busybox"' > ${OS_RELEASE_FILE} && \
    echo 'NAME="Debian GNU/Linux"' >> ${OS_RELEASE_FILE} && \
    echo 'ID="debian"' >> ${OS_RELEASE_FILE} && \
    echo 'VERSION_ID="'${VERSION}'"' >> ${OS_RELEASE_FILE} && \
    echo 'VERSION="Debian GNU/Linux '${VERSION}' ('${CODENAME}')"' >> ${OS_RELEASE_FILE} && \
    echo 'HOME_URL="https://github.com/prometheus/busybox"' >> ${OS_RELEASE_FILE} && \
    echo 'SUPPORT_URL="https://github.com/prometheus/busybox/blob/master/README.md"' >> ${OS_RELEASE_FILE} && \
    echo 'BUG_REPORT_URL="https://github.com/prometheus/busybox/issues/new"' >> ${OS_RELEASE_FILE}

RUN ln -s /usr/lib/os-release /rootfs/etc/os-release

FROM        ${ARCH}busybox:uclibc
MAINTAINER  The Prometheus Authors <prometheus-developers@googlegroups.com>

COPY --from=0 /rootfs /
