ARG ARCH=""
FROM ${ARCH}debian:stretch

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

FROM        ${ARCH}busybox:uclibc
MAINTAINER  The Prometheus Authors <prometheus-developers@googlegroups.com>

COPY --from=0 /rootfs /
