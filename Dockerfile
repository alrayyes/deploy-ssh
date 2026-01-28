FROM alpine:3.23.3@sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659

RUN apk --no-cache add openssh-client-default=10.2_p1-r0 && \
    mkdir -p /root/.ssh

COPY config /root/.ssh/config

RUN chmod 600 /root/.ssh/config
