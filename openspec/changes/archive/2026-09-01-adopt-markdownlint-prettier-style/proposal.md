## Why

`rules/markdown.md` says not to hand-roll the list of markdownlint rules
that overlap with Prettier's formatting decisions — extend the bundled
`markdownlint/style/prettier` style instead, and re-enable the line-length
rule under its alias (`line-length:`), never the raw `MD013:` key, because
`extends` merges on the literal key and a stray `MD013:` block would sit
beside the inherited `line-length: false` and lose silently. This repo's
`.markdownlint-cli2.yaml` does neither: no `extends`, and the line-length
override is still written as `MD013:`.

## What Changes

- Add `extends: "markdownlint/style/prettier"` to `.markdownlint-cli2.yaml`'s
  `config` block.
- Rename the `MD013:` override to `line-length:` so it actually takes effect
  once the bundled style disables the raw key.
- Run `bun run lint:md` afterward and fix anything the newly-enabled rules
  flag in the repo's existing Markdown.

## Capabilities

No spec-level behavior changes — this is linter configuration, not
application or CI behavior (the CI job that runs markdownlint doesn't
change, only what it checks). `skip_specs: true` is set in `.openspec.yaml`.

### New Capabilities

None.

### Modified Capabilities

None.

## Impact

- `.markdownlint-cli2.yaml` config changes.
- Possible small Markdown formatting fixes if the bundled style flags
  something Prettier already produced differently.
