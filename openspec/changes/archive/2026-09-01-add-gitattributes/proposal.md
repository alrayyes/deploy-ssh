## Why

`rules/git.md` requires every repo to carry a `.gitattributes` — this one
doesn't have one. Without `text=auto eol=lf`, a contributor on Windows can
turn a diff into line-ending noise, and `bun.lock` renders as thousands of
unreadable lines in every diff view instead of collapsing.

## What Changes

- Add `.gitattributes` at the repo root: the standard `text=auto eol=lf`
  baseline, CRLF for Windows script extensions, binary markers for the image
  assets this repo could carry, and a `-diff` marker on `bun.lock` so a diff
  view collapses it instead of rendering the whole lockfile.

## Capabilities

No spec-level behavior changes — this is repo configuration, not application
or CI behavior. `skip_specs: true` is set in `.openspec.yaml`.

### New Capabilities

None.

### Modified Capabilities

None.

## Impact

- New file: `.gitattributes`.
- No code, CI, or runtime behavior changes.
