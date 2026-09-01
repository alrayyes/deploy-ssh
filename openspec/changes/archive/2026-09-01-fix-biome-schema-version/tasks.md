## 1. Fix the schema pin

- [x] 1.1 Update `biome.json`'s `$schema` URL from `2.5.7` to `2.5.11`,
      matching the pinned `@biomejs/biome` devDependency in `package.json`
- [x] 1.2 Run `bun run lint` and verify it still passes with no new
      findings (the schema-mismatch info that was there is now gone)
