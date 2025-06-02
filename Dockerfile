FROM alpine:3.22.0@sha256:8a1f59ffb675680d47db6337b49d22281a139e9d709335b492be023728e11715

RUN apk --no-cache add openssh-client=10.0_p1-r7 && \
  mkdir -p /root/.ssh

COPY config /root/.ssh/config
