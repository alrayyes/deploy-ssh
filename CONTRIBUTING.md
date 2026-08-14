# Contributing

## What you need

- **bun** `1.3.14`, pinned in `.bun-version`. It installs the dev dependencies
  and runs the hooks; there is no node in this repo any more.
- **Docker**, to build the image and to run hadolint.

That is the whole toolchain. Everything else arrives through `bun install`.

## Getting set up

```
bun install
```

That installs the dependencies and, through the `prepare` script, installs
lefthook's git hooks. Do it before your first commit — the hooks are most of
what stops CI being the place you find things out.

## The checks

Run what the pipeline runs:

```
bun run lint                                              # biome
docker compose run --rm -T hadolint hadolint Dockerfile   # Dockerfile
docker build .                                            # it still builds
```

The hooks run the same commands, which is the point — they cannot drift from CI
if there is one copy of each:

- **pre-commit** formats staged files with biome and restages what it touched,
  then runs hadolint and a build if you touched the `Dockerfile`. It may write.
- **commit-msg** runs commitlint.
- **pre-push** runs all three in check mode over the whole tree. It never
  writes: a hook rewriting files under a push leaves the pushed commit and your
  working tree disagreeing about what was reviewed.

CI adds one check the hooks cannot: it runs the built image and asserts that
`bash`, `git`, `node`, `python3`, `ssh` and `scp` all resolve and that `ssh -G`
reports `accept-new`. If Alpine renames or drops a package, `apk add` still
succeeds for the rest and the build stays green — the failure would otherwise
turn up in somebody's deploy.

## Commits

[Conventional Commits](https://www.conventionalcommits.org/), enforced by
commitlint on `@commitlint/config-conventional` unextended. The format is not
decoration: release-please reads it to decide the next version, so a commit that
does not parse gets no changelog entry and moves no version.

- `fix:` takes the patch, `feat:` the minor, a `BREAKING CHANGE:` footer the
  major.
- `chore:` and `docs:` release nothing. That is deliberate for tooling — bumping
  biome should not republish a byte-identical container — and it is why a base
  image bump is configured to raise `fix(deps):` instead.

One logical change per commit, each building and passing its own tests. A
refactor and a feature are two commits.

## Changing the Dockerfile

Two things there are load-bearing, and both have their reasoning written beside
them:

- **Alpine package versions are deliberately unpinned**, and hadolint's DL3018
  is disabled in `.hadolint.yaml` to allow it. An apk version belongs to the
  Alpine branch the base image is built on rather than to this file, and Alpine
  keeps one build per branch and prunes the rest — so there is no version list
  for Renovate to read and no archive to pin against. Read that file in full
  before adding a seventh package.
- **The base image digest is pinned**, and that is the part that is genuinely
  reproducible. Renovate moves it.

Adding a package makes the image bigger for everyone pulling it, so it wants an
argument in the commit message, not just a line in the `RUN`.

## Opening a pull request

Branch, push, open a pull request — nothing lands on `main` directly. Read your
own diff first; if it carries two changes, say so at the top of the description
rather than leaving it to be found.

Label it: a `kind/` for what it is and a `topic/` for the area it touches.

Spend the description on **why**. The diff already says what.

## Releasing

You do not. release-please keeps a release pull request open against `main`
carrying the next version and the changelog entry; merging it tags the release,
and the same run builds the image, pushes it to `ghcr.io` and attests its
provenance.

It is one workflow rather than two because a tag pushed with `GITHUB_TOKEN`
starts no further workflow run — a separate on-tag workflow would silently never
fire, and the first symptom is a release with no image against it.
