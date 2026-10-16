## 1. Gate

- [x] 1.1 Replace the `audit` job's install and `bun run audit` with the
      `advisory-scan` action in `gate` mode, behind a manifest and lockfile check
- [x] 1.2 Drop the ignore from `package.json` and `CONTRIBUTING.md`

## 2. Scan

- [x] 2.1 Add `advisory-scan.yml`: daily, lockfile push, `workflow_dispatch`,
      `contents: read` and `issues: write`
- [ ] 2.2 After merge, run it once and confirm the `Dependency advisories`
      issue appears (braces is expected)
