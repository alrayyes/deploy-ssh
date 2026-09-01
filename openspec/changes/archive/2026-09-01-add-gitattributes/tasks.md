## 1. Add .gitattributes

- [x] 1.1 Create `.gitattributes` at the repo root with `text=auto eol=lf`,
      CRLF for `.cmd`/`.bat`/`.ps1`, binary markers for image extensions,
      and `-diff` on `bun.lock`, and verify `git check-attr -a bun.lock`
      reports `diff: unset` (git's name for an explicitly unset attribute)
- [x] 1.2 Verify `git diff` still runs clean on the existing tree (no
      unexpected renormalization noise) with `git status --short`
