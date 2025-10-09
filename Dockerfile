FROM alpine:3.22.2@sha256:4b7ce07002c69e8f3d704a9c5d6fd3053be500b7f1c69fc0d80990c2ad8dd412

RUN apk --no-cache add openssh-client-default=10.0_p1-r9 && \
    mkdir -p /root/.ssh

COPY config /root/.ssh/config

RUN chmod 600 /root/.ssh/config
