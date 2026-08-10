FROM alpine:3.24.1@sha256:28bd5fe8b56d1bd048e5babf5b10710ebe0bae67db86916198a6eec434943f8b

# Deliberately unpinned. An apk version belongs to the Alpine branch this image
# is built on, not to this file, and Renovate only ever bumps the line above —
# so every time the branch moved, someone had to notice and hand-bump the pin.
# That is what 99e2c18 and 0059870 are: two commits called "bump
# openssh-client-default", six months apart, doing by hand what no tool could do
# for them. Alpine keeps one build of each package per branch and prunes the
# rest, so there is no version list for Renovate to read and no archive to pin
# against. The pin bought no reproducibility for that toil either — apk reads
# the live mirror at build time whatever the digest above says.
RUN apk --no-cache add openssh-client-default && \
    mkdir -p /root/.ssh

COPY config /root/.ssh/config

RUN chmod 600 /root/.ssh/config
