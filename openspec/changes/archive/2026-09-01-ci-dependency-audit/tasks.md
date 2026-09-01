## 1. Add the audit step

- [x] 1.1 Add a `bun audit` step (new step in the existing `lint` job, or a
      new `audit` job) to `.github/workflows/ci.yml`, running on every push
      and pull request (added as its own `audit` job, plus a `bun run audit`
      script and a pre-push hook entry for local parity)
- [x] 1.2 Verify locally with `bun audit` that the current lockfile passes
      clean
- [x] 1.3 Push a branch and verify the new CI job/step runs and reports a
      pass in the pull request's checks
