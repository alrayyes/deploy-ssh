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
- [ ] 3.2 Push a candidate image, hand `vps-docker` the tag/digest, and get
      a real `workflow_dispatch` run against it confirming SSH auth and a
      completed deploy - the one thing that can't be verified by reading
      YAML (whether the runner's job workspace is writable by a non-root
      UID)
- [ ] 3.3 Real review before merge, per issue #31's definition of done -
      not a self-merge
