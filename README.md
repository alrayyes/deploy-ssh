# deploy-ssh

[![CI](https://github.com/alrayyes/deploy-ssh/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/alrayyes/deploy-ssh/actions/workflows/ci.yml)
[![release](https://img.shields.io/github/v/release/alrayyes/deploy-ssh?sort=semver)](https://github.com/alrayyes/deploy-ssh/releases/latest)
[![image](https://img.shields.io/badge/ghcr.io-deploy--ssh-2496ED?logo=docker&logoColor=white)](https://github.com/alrayyes/deploy-ssh/pkgs/container/deploy-ssh)
[![licence](https://img.shields.io/badge/licence-GPL--3.0--or--later-blue)](LICENSE)

An Alpine image carrying what a deploy job needs, so the job stops installing it
on every run.

```text
ghcr.io/alrayyes/deploy-ssh:latest
```

It exists because the alternative is running `apk add` at the top of every
deploy: six packages, fetched from the Alpine mirrors, every time anything
ships. That is a minute of somebody's pipeline and a dependency on a mirror
being up, paid over and over for an answer that never changes.

## Requirements

A container runtime that can pull from `ghcr.io`, and nothing else. The package
is public, so no registry credentials.

The image is `linux/amd64` only.

## What's in it

| Package                  | Why                                                                                                                                                      |
| ------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `openssh-client-default` | `ssh` and `scp` — the thing the image is named after                                                                                                     |
| `bash`                   | deploy scripts that use arrays need a real bash, not Alpine's `ash`                                                                                      |
| `git`, `ca-certificates` | so `actions/checkout` clones over HTTPS with the system CA store instead of pulling a tarball through node                                               |
| `nodejs`                 | `actions/checkout` **is** a node program whichever way it fetches. Without it the step never starts: `exec: "node": executable file not found`, exit 127 |
| `python3`                | for the deploy script that parses JSON on its way to finding a host                                                                                      |

That is the whole image. It has no entrypoint of its own and runs nothing — it is
somewhere for a CI job to stand.

## Configuration

It runs as a non-root user (`1000:1000`) and ships one file,
`/home/deploy/.ssh/config`:

```text
StrictHostKeyChecking accept-new
```

`accept-new` is the honest setting for a container rebuilt on every job. A
`known_hosts` file would be re-learned each run, so a pinned host key buys
nothing, while `accept-new` still refuses a key that _changes_ mid-run. A job
wanting something stricter writes its own config over it.

There is nothing else to configure. No environment variables, no flags.

## Using it

As the container a CI job runs in:

```yaml
jobs:
  deploy:
    runs-on: docker
    container:
      image: ghcr.io/alrayyes/deploy-ssh:1.3.0@sha256:16c9f0da8f975159133689c92d0520fd2655aebe381019cbefe6f1b272680265
    steps:
      - uses: actions/checkout@v5
      - run: ./deploy.sh "$DEPLOY_HOST"
```

Pin the version **and** the digest. The version is what makes a bump readable in
review; the digest is what actually runs. `latest` on its own is a floating
reference, and a deploy that silently changes what it runs is the thing this
image is meant to stop.

Verify where an image came from:

```sh
gh attestation verify oci://ghcr.io/alrayyes/deploy-ssh:latest --repo alrayyes/deploy-ssh
```

Every release is built by [the release workflow](.github/workflows/release.yml)
and attested, so that command tells you which commit and which run produced the
digest you are about to run.

## Releasing

Nobody picks a version. release-please reads the Conventional Commits that land
on `main` and keeps a release pull request open carrying the next version and the
changelog entry. Merging it tags the release, and the same run builds the image,
pushes it and attests it.

Tags are bare semver — `1.3.0`, not `v1.3.0`.

A base image bump raises `fix(deps):` rather than `chore(deps):` on purpose. A
patched Alpine has to cut a release, or the fix never becomes an image anyone
pulls.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for the toolchain, the checks and how a
change gets released. Security reports go through
[SECURITY.md](SECURITY.md), not the issue tracker.

## Licence

GPL-3.0-or-later. See [LICENSE](LICENSE).
