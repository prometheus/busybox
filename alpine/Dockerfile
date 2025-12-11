ARG ARCH=""
FROM docker.io/${ARCH}alpine:3.23.0 AS builder

RUN apk add --no-cache \
    tzdata \
    ca-certificates \
    busybox-static

FROM scratch AS install

COPY --from=builder /bin/busybox.static /bin/busybox
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=builder /etc/services /etc/services

# Copy Alpine's built-in user + group DB
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group

# Install BusyBox applets
RUN ["/bin/busybox", "--install", "-s", "/bin"]

FROM scratch

LABEL org.opencontainers.image.authors="The Prometheus Authors <prometheus-developers@googlegroups.com>"
LABEL org.opencontainers.image.title="Prometheus BusyBox"
LABEL org.opencontainers.image.description="Minimal BusyBox image for Prometheus based on Alpine 3.23.0"
LABEL org.opencontainers.image.version="3.23.0"
LABEL org.opencontainers.image.source="https://github.com/prometheus/busybox"

COPY --from=install / /

# Run as the built-in nobody user
USER nobody
