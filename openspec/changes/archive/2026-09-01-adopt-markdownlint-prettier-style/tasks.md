## 1. Adopt the bundled Prettier-aligned style

- [x] 1.1 Add `extends: "markdownlint/style/prettier"` to
      `.markdownlint-cli2.yaml`'s `config` block and rename the `MD013:`
      override to `line-length:`
- [x] 1.2 Run `bun run lint:md` and verify it passes, fixing any Markdown
      the newly-enabled rules flag (none needed - clean on the first run)
- [x] 1.3 Run `bun run format:check` and verify Prettier and markdownlint
      still agree on layout (no rule fighting Prettier's output)
