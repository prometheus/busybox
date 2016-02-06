FROM debian:jessie

RUN \
    apt-get update && apt-get install -y \
      ca-certificates \
      gcc \
    && rm -rf /var/lib/apt/lists/*

RUN set -x \
    && mkdir -p rootfs/lib \
    && set -- \
        /etc/ssl/certs/ca-certificates.crt \
        /usr/share/zoneinfo \
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

