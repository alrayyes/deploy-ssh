## 1. Issue forms

- [x] 1.1 Add `.github/ISSUE_TEMPLATE/bug_report.yml` with required
      textareas for description, reproduction steps, and expected behavior
- [x] 1.2 Add `.github/ISSUE_TEMPLATE/feature_request.yml` with required
      textareas for description (user story), acceptance criteria
      (Given/When/Then), and definition of done
- [x] 1.3 Verified both forms parse as valid GitHub issue-form YAML with
      every field's `validations.required: true` set (`python3 -c "import
      yaml..."` against both files); full picker/blocked-submission
      behavior is standard GitHub form rendering once these land on the
      default branch

## 2. Pull request template

- [x] 2.1 Add `.github/PULL_REQUEST_TEMPLATE.md` with a summary section and
      a test-plan checklist
- [x] 2.2 `bun run lint:md` and `format:check` pass on the template; the
      pre-fill itself is standard GitHub behavior for any
      `PULL_REQUEST_TEMPLATE.md` on the base branch, confirmed once merged
