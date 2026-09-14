## Why

`biome.json`'s `$schema` has drifted from the `@biomejs/biome` version
pinned in `package.json` twice now: first `2.5.7` vs. `2.5.11` (#36, fixed
by hand in #43), then `2.5.11` vs. `2.5.13` after Dependabot bumped the
devDependency in #58 without touching the schema URL (#61, corrected again
by hand in #63). Both fixes were manual edits that don't survive the next
automated bump — Dependabot has no reason to know `biome.json`'s `$schema`
field exists, and nothing else checks the two agree.

## What Changes

- Add `scripts/check-biome-schema.sh`, comparing the version in
  `biome.json`'s `$schema` URL against the `@biomejs/biome` version pinned
  in `package.json`'s `devDependencies`, failing when they disagree.
- Expose it as `bun run check:biome-schema`.
- Wire it into `lefthook.yml`'s `pre-push` and into `ci.yml`'s `lint` job,
  alongside the other check-mode lint commands.
- Document it in `CONTRIBUTING.md`'s "The checks" section.

## Capabilities

No spec-level behavior changes — this only affects editor tooling
validation and the pipeline's own checks, not anything `biome check`
enforces on the code it lints. `skip_specs: true` is set in
`.openspec.yaml`.

### New Capabilities

None.

### Modified Capabilities

None.

## Impact

- `scripts/check-biome-schema.sh` (new), `package.json`, `lefthook.yml`,
  `.github/workflows/ci.yml`, `CONTRIBUTING.md`.
- A future Dependabot bump of `@biomejs/biome` that lands without a
  matching `biome.json` edit now fails `pre-push` and CI instead of
  drifting silently until the next manual audit.
