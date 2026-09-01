## 1. Dockerfile

- [x] 1.1 Add a `deploy` user/group (UID/GID 1000), own `/home/deploy/.ssh`
      as that user, and set `HOME=/home/deploy`
- [x] 1.2 Move the shipped config from `/root/.ssh/config` to
      `/home/deploy/.ssh/config`, `chmod 600`, and verify `docker run --rm
      <image> id` reports a non-root UID
- [x] 1.3 Switch to a numeric `USER 1000:1000` (not the name) and verify
      `hadolint` is clean with no new exceptions beyond the already-justified
      DL3018

## 2. Docs

- [x] 2.1 Update `README.md`'s Configuration section for the new path and
      non-root user
- [x] 2.2 Update `SECURITY.md`'s "What this image is exposed to" section,
      which stated the image runs as root

## 3. Cross-repo verification

- [x] 3.1 Coordinate with the `vps-docker` session: confirm its deploy
      workflow has no hard dependency on root or `/root/.ssh` (confirmed -
      it already writes to `~/.ssh/...`, and flagged that `$HOME` has to
      be set explicitly for the new user)
- [x] 3.2 `vps-docker` pushed the candidate (built from `fix/non-root-user`
      @ `a68da18`) as a temporary `ghcr.io/alrayyes/deploy-ssh:test-non-root`
      tag and ran it through a real `workflow_dispatch` against
      `deploy.yml`, pinned by digest. Confirmed clean: SSH connection
      opened, host key accepted (`accept-new`), headscale tailnet lookup
      succeeded, all 25 deploy targets staged, zero permission errors under
      UID 1000/GID 1000 with `HOME=/home/deploy`. The run's one failure
      (`tailscale/ts-authkey-default.env` missing on the server) reproduced
      identically with Ryan's own native SSH right after - a pre-existing
      gap in server state, unrelated to this change.
- [ ] 3.3 Real review before merge, per issue #31's definition of done -
      not a self-merge. Ryan green-lit proceeding to review via the
      `vps-docker` session; PR marked ready for review.
