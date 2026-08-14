FROM alpine:3.24.1@sha256:28bd5fe8b56d1bd048e5babf5b10710ebe0bae67db86916198a6eec434943f8b

# What a deploy job needs, in the image rather than installed on every run.
#
# The six below are exactly what vps-docker's deploy job used to `apk add` into a
# bare alpine on every deploy, and each one is here for a reason that bites when it
# is missing:
#
#   openssh-client-default  ssh and scp - the thing this image is named after
#   bash                    deploy.sh is bash and uses arrays
#   git, ca-certificates    so actions/checkout clones over HTTPS with the system
#                           CA store instead of fetching a tarball through node
#   nodejs                  actions/checkout *is* a node program whichever way it
#                           then fetches. Without it the step never starts:
#                           `exec: "node": executable file not found`, exit 127
#   python3                 deploy.sh parses headscale's JSON with it to find the
#                           tailnet IP. Missing, the lookup returns nothing and the
#                           script dies pointing at headscale rather than at a
#                           missing interpreter
#
# Deliberately unpinned. An apk version belongs to the Alpine branch this image is
# built on, not to this file, and Renovate only ever bumps the line above — so every
# time the branch moved, someone had to notice and hand-bump the pin. That is what
# 9919a78 and 9e7b91b are: two commits called "bump openssh-client-default", six
# months apart, doing by hand what no tool could do for them. Alpine keeps one build
# of each package per branch and prunes the rest, so there is no version list for
# Renovate to read and no archive to pin against. The pin bought no reproducibility
# for that toil either — apk reads the live mirror at build time whatever the digest
# above says.
RUN apk --no-cache add \
        bash \
        ca-certificates \
        git \
        nodejs \
        openssh-client-default \
        python3 && \
    mkdir -p /root/.ssh

COPY config /root/.ssh/config

RUN chmod 600 /root/.ssh/config
