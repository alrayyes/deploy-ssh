# A named stage rather than COPY --from=<image>: Dependabot's Docker updater reads FROM
# lines and nothing else, so this is what lets it raise a pull request for a new
# hush-hush-cli release. It is only a source for the COPY below, never the final image.
FROM ghcr.io/alrayyes/hush-hush-cli:1.24.5@sha256:e05eac35cfff86258320f565423c7edf338d83649c1c2649f503ebf1dbcc07bf AS hush-hush-cli

FROM alpine:3.24.3@sha256:be2656061b536c1883c4034790e21d0a09c5aaaf51968b89368a3c0371ea2c9a

# What a deploy job needs, in the image rather than installed on every run.
#
# The first six below are exactly what a real deploy job used to `apk add` into a
# bare alpine on every deploy, and each one is here for a reason that bites when it
# is missing. curl joined later:
#
#   openssh-client-default  ssh and scp - the thing this image is named after
#   bash                    deploy.sh is bash and uses arrays
#   git, ca-certificates    so actions/checkout clones over HTTPS with the system
#                           CA store instead of fetching a tarball through node
#   nodejs                  actions/checkout *is* a node program whichever way it
#                           then fetches. Without it the step never starts:
#                           `exec: "node": executable file not found`, exit 127
#   curl                    alrayyes/hush-hush-action downloads its command-line tool and checksums
#                           with it. Missing, the secrets fetch fails before any
#                           deploy step runs
#   python3                 deploy.sh parses headscale's JSON with it to find the
#                           tailnet IP. Missing, the lookup returns nothing and the
#                           script dies pointing at headscale rather than at a
#                           missing interpreter
#
#   hush-hush-cli           fetches secrets from hush-hush. Copied in from its own
#                           minimal image rather than apk-installed, since it is
#                           not an Alpine package. A static Go binary, so it needs
#                           nothing else here. Without it a deploy job has to download
#                           it on every run
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
        curl \
        git \
        nodejs \
        openssh-client-default \
        python3 && \
    addgroup -g 1000 deploy && \
    adduser -D -u 1000 -G deploy -h /home/deploy deploy && \
    mkdir -p /home/deploy/.ssh && \
    chown -R deploy:deploy /home/deploy/.ssh && \
    chmod 700 /home/deploy/.ssh

COPY --from=hush-hush-cli /hush-hush-cli /usr/local/bin/hush-hush-cli

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
