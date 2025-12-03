ARG ARCH=""
ARG TAG="3.22.2"
FROM        docker.io/${ARCH}alpine:${TAG} as builder

RUN apk upgrade -U && \
    apk add tzdata ca-certificates busybox-static

FROM        scratch AS install

COPY --from=builder /bin/busybox.static /bin/busybox
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo

RUN ["/bin/busybox", "--install", "-s", "/bin"]

FROM        scratch
MAINTAINER  The Prometheus Authors <prometheus-developers@googlegroups.com>

COPY --from=install / /

