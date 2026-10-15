## Why

The audit job failed every pull request the day an advisory was published
against a pin nobody touched, and `package.json` carried
`--ignore=GHSA-vfj7-8cjw-p6xm` to keep it green. The ignore hid the finding
from the only place that could track it. `rules/dependencies.md` splits the
job in two instead: a pull request check for what the change introduces, and
a scan of the default branch that keeps one ticket (#95).

## What Changes

- The `audit` job in `ci.yml` runs `alrayyes/advisory-scan` in `gate` mode:
  it fails only on advisories the pull request adds to `bun.lock`, and its
  steps run only when `package.json` or `bun.lock` changed.
- A new `advisory-scan.yml` runs the same action in `scan` mode on the default
  branch, daily, on a manifest or lockfile push and on demand, and keeps one
  open `Dependency advisories` issue.
- The GHSA-vfj7 ignore is gone from `package.json` and `CONTRIBUTING.md`.
  `bun run audit` and the `pre-push` hook now report everything.

## Capabilities

### Modified Capabilities

- `ci/dependency-audit`: from "fail on any advisory" to "fail on what the
  change introduces, and keep a ticket for the rest".

## Impact

- `.github/workflows/ci.yml`, `.github/workflows/advisory-scan.yml`,
  `package.json`, `CONTRIBUTING.md`.
- Until braces publishes a fix, `bun run audit` exits non-zero locally and the
  `pre-push` hook with it. CI doesn't, since the gate compares against the base.
