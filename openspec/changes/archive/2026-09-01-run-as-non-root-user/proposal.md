## Why

`rules/containers.md` requires every image to run non-root - "a process
that starts non-root begins with zero Linux capabilities, privilege
escalation needs a kernel bug even before anything drops capabilities at
runtime." `deploy-ssh`'s image has no `USER` directive and runs as root,
tracked as https://github.com/alrayyes/deploy-ssh/issues/31. It wasn't
fixed directly because the image writes `~/.ssh/config` and is consumed by
`vps-docker`'s deploy pipeline, which needed verifying against the real
change before it landed - not just a Dockerfile edit that happens to
build.

Coordinated directly with the `vps-docker` session: its deploy workflow
already writes the SSH key and config to `~/.ssh/...` rather than
`/root/.ssh/...` (a deliberate defensive choice, per a comment already in
that workflow), doesn't otherwise depend on UID 0, and needs `$HOME` set
explicitly for the new user since a non-login shell won't resolve it from
`/etc/passwd` on its own.

## What Changes

- Add a non-root user (`deploy`, UID/GID 1000) to the image, own the
  `.ssh` directory and config as that user, set `HOME` explicitly, and run
  as `USER 1000:1000` (numeric, not the name - hadolint's DL3066 flags a
  non-numeric `USER` as possibly unresolvable by the host system).
- Move the shipped SSH config from `/root/.ssh/config` to
  `/home/deploy/.ssh/config`.
- Update `README.md` and `SECURITY.md`, which both stated the image runs
  as root and named the old config path.

## Capabilities

### New Capabilities

- `image/user`: the published image runs its default process as a
  non-root user.

### Modified Capabilities

None.

## Impact

- `Dockerfile`, `README.md`, `SECURITY.md`.
- `vps-docker`'s deploy workflow is unaffected by design (it already
  writes to `~/.ssh/...`, not a hardcoded `/root/.ssh/...`), but still
  needs a real `workflow_dispatch` run against a candidate image to
  confirm the runner's job workspace is writable by a non-root UID - the
  one thing that can't be verified by reading the workflow YAML.
- Not self-merged: issue #31's definition of done wants real review before
  merge, and the `vps-docker` verification run touches production.
