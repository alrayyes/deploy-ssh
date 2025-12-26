FROM alpine:3.23.2@sha256:865b95f46d98cf867a156fe4a135ad3fe50d2056aa3f25ed31662dff6da4eb62

RUN apk --no-cache add openssh-client-default=10.2_p1-r0 && \
    mkdir -p /root/.ssh

COPY config /root/.ssh/config

RUN chmod 600 /root/.ssh/config
