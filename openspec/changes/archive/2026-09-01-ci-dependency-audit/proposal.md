## Why

`rules/dependencies.md` requires the ecosystem's own audit tool running in
CI, on every push, separately from whatever raises the update pull request —
for bun/npm that's `bun audit`. This repo pins every dependency and has
Dependabot watching all three ecosystems, but nothing checks whether an
already-pinned version has a since-published CVE. Pinning stops a version
drifting under you; it says nothing about the pinned version being safe.

## What Changes

- Add a `bun audit` step to the CI `lint` job (or a new job) in
  `.github/workflows/ci.yml`, running on every push and pull request, so a
  vulnerable devDependency fails the pipeline the same way a lint error
  does.

## Capabilities

### New Capabilities

- `ci/dependency-audit`: CI runs `bun audit` on every push and pull request
  and fails the job when it reports a vulnerability.

### Modified Capabilities

None.

## Impact

- `.github/workflows/ci.yml` gains a step (or job).
- A pull request that pins a devDependency with a known vulnerability now
  fails CI instead of merging silently.
