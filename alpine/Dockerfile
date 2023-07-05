ARG ARCH=""
FROM        ${ARCH}alpine:latest as alpine

RUN apk upgrade -U && \
    apk add tzdata ca-certificates

# Use the busybox.static to avoid dynamic library dependencies.
RUN apk add busybox-static && \
    mv /bin/busybox.static /bin/busybox && \
    /bin/busybox --install -s /bin

# remove extra package
RUN apk del libc-utils

# remove apk files and directories
RUN apk del apk-tools && \
    find / -name apk -prune -exec rm -rf {} ";"


# remove extraneous folders
RUN rm -rf media mnt opt run srv

FROM        scratch
MAINTAINER  The Prometheus Authors <prometheus-developers@googlegroups.com>

COPY --from=alpine / /

