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
# built on, not to this file, and only the digest above gets bumped when the branch
# moves — so every time it did, someone had to notice and hand-bump the pin. That is
# what 9919a78 and 9e7b91b are: two commits called "bump openssh-client-default",
# six months apart, done by hand. Alpine keeps one build of each package per branch
# and prunes the rest, so there is no version list to read and no archive to pin
# against. The pin bought no reproducibility for that toil either — apk reads the
# live mirror at build time whatever the digest above says.
RUN apk --no-cache add \
        bash \
        ca-certificates \
        git \
        nodejs \
        openssh-client-default \
        python3 && \
    addgroup -g 1000 deploy && \
    adduser -D -u 1000 -G deploy -h /home/deploy deploy && \
    mkdir -p /home/deploy/.ssh && \
    chown -R deploy:deploy /home/deploy/.ssh && \
    chmod 700 /home/deploy/.ssh

COPY --chown=deploy:deploy config /home/deploy/.ssh/config

RUN chmod 600 /home/deploy/.ssh/config

# HOME is set explicitly rather than left to whatever adduser wrote to
# /etc/passwd: Docker doesn't export it as an environment variable just
# because USER points at an entry with a home directory, and a shell that
# isn't a login shell won't resolve it from passwd either - the deploy job's
# own `~` expansion for its SSH key and config needs $HOME to actually be
# set, not just resolvable.
ENV HOME=/home/deploy
USER 1000:1000
