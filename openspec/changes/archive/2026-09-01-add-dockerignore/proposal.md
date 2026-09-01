## Why

`rules/containers.md` requires a `.dockerignore` doing for the build context
what `.gitignore` does for a commit — this repo has none. `docker build .`
currently streams the whole working directory to the daemon, including
`node_modules`, `.git`, `openspec/` and every dotfile that no `COPY`
instruction ever names.

## What Changes

- Add `.dockerignore` at the repo root, excluding `.git`, `node_modules`,
  `.bun-cache`, `openspec/`, `.claude/`, and the local editor/OS droppings
  already covered in `.gitignore`.

## Capabilities

No spec-level behavior changes — the built image is byte-identical either
way, since nothing in the Dockerfile does a bare `COPY . .`. This only
shrinks the build context. `skip_specs: true` is set in `.openspec.yaml`.

### New Capabilities

None.

### Modified Capabilities

None.

## Impact

- New file: `.dockerignore`.
- Smaller build context sent to the Docker daemon on every build.
