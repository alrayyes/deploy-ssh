## 1. Add the check

- [x] 1.1 Write `scripts/check-biome-schema.sh`, comparing
      `package.json`'s pinned `@biomejs/biome` version against the version
      in `biome.json`'s `$schema` URL
- [x] 1.2 Add a `check:biome-schema` script to `package.json` running it
- [x] 1.3 Verify it fails when the two versions are deliberately
      mismatched, and passes once restored

## 2. Wire it in

- [x] 2.1 Add it to `lefthook.yml`'s `pre-push` jobs
- [x] 2.2 Add it to `.github/workflows/ci.yml`'s `lint` job
- [x] 2.3 Document it in `CONTRIBUTING.md`'s "The checks" section
