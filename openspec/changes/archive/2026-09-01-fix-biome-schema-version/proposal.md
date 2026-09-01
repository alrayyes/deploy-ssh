## Why

`biome.json`'s `$schema` points at `2.5.7`, but `package.json` pins
`@biomejs/biome` at `2.5.11` — the two have drifted apart across the last
few Dependabot bumps (`da2df3a`, `d0097fc`), most likely because bumping the
devDependency doesn't touch the schema URL. A stale schema gives an editor
wrong validation and autocomplete for whatever changed between 2.5.7 and
2.5.11.

## What Changes

- Update `biome.json`'s `$schema` URL to `2.5.11`, matching the pinned
  `@biomejs/biome` devDependency.

## Capabilities

No spec-level behavior changes — the schema URL only affects editor
tooling, not what `biome check` actually enforces. `skip_specs: true` is set
in `.openspec.yaml`.

### New Capabilities

None.

### Modified Capabilities

None.

## Impact

- `biome.json` schema URL only.
- No lint rule changes; `bun run lint` behavior is unaffected.
