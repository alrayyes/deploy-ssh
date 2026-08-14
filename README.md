# deploy-ssh

An Alpine image carrying what a deploy job needs, so the job stops installing it
on every run.

```
ghcr.io/alrayyes/deploy-ssh:latest
```

## What's in it

| | Why |
| --- | --- |
| `openssh-client-default` | `ssh` and `scp` — the thing the image is named after |
| `bash` | deploy scripts that use arrays need a real bash, not Alpine's `ash` |
| `git`, `ca-certificates` | so `actions/checkout` clones over HTTPS with the system CA store instead of pulling a tarball through node |
| `nodejs` | `actions/checkout` *is* a node program whichever way it fetches. Without it the step never starts: `exec: "node": executable file not found`, exit 127 |
| `python3` | for scripts that parse JSON on the way to finding a host |

It also ships `/root/.ssh/config` with `StrictHostKeyChecking accept-new`, which
is the honest setting for a container that is rebuilt for every job: a
`known_hosts` file would be re-learned each run anyway, so a pinned host key buys
nothing, while `accept-new` still refuses a key that *changes* mid-run. A job
that wants stricter can write its own config over it.

## Using it

As the container a CI job runs in:

```yaml
jobs:
  deploy:
    runs-on: docker
    container:
      image: ghcr.io/alrayyes/deploy-ssh:latest@sha256:...
    steps:
      - uses: actions/checkout@...
      - run: ./deploy.sh "$DEPLOY_HOST"
```

Pin the digest and let Renovate move it. `latest` on its own is a floating
reference; `latest@sha256:...` is a name for one specific image that a tool can
raise a pull request to change.

The package is public, so pulling it needs no credentials.

Verify where it came from:

```
gh attestation verify oci://ghcr.io/alrayyes/deploy-ssh:latest --repo alrayyes/deploy-ssh
```

## Working on it

```
bun install
bun run lint
docker build .
docker compose run --rm -T hadolint hadolint Dockerfile
```

`bun install` installs the git hooks through lefthook, which run the same three
checks before a commit and a push, so CI should rarely be the first to tell you.

Alpine package versions are deliberately **not** pinned. An apk version belongs
to the Alpine branch the base image is built on rather than to the Dockerfile,
and Alpine keeps one build of each package per branch and prunes the rest — so
there is no version list for Renovate to read and no archive to pin against. The
base image digest is pinned, which is the part that is actually reproducible.
See `.hadolint.yaml` for the argument in full before adding a seventh package.

## Releasing

Nobody picks a version. release-please reads the Conventional Commits that land
on `main` and keeps a release pull request open carrying the next version and
the changelog entry. Merging it tags the release, and the same run builds the
image, pushes it to `ghcr.io` and attests its provenance.

Tags are bare semver — `1.2.87`, not `v1.2.87`.

## Licence

GPL-3.0-or-later. See [LICENSE](LICENSE).
