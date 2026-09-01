## Why

`rules/docs.md` requires GitHub's YAML issue forms — `bug_report.yml` and
`feature_request.yml` under `.github/ISSUE_TEMPLATE/`, each encoding the
same four-part shape `skills/write-issue/` requires (description,
reproduction/acceptance criteria, definition of done) as required form
fields — plus a terse `PULL_REQUEST_TEMPLATE.md`. This repo has neither, so
an issue filed through the GitHub UI right now gets a blank textbox with no
structure at all.

## What Changes

- Add `.github/ISSUE_TEMPLATE/bug_report.yml`: required textareas for
  `description`, `reproduction` ("steps to reproduce"), `expected`.
- Add `.github/ISSUE_TEMPLATE/feature_request.yml`: required textareas for
  `description` ("As a ‹who›, I want ‹what›, so that ‹why›"),
  `acceptance_criteria` ("Given/When/Then, 3-5 testable rules"),
  `definition_of_done`.
- Add `.github/PULL_REQUEST_TEMPLATE.md`: a summary section and a test-plan
  checklist, nothing else — the linked issue already carries acceptance
  criteria and definition of done.

## Capabilities

### New Capabilities

- `contribution/issue-templates`: opening a new bug report or feature
  request through GitHub's UI presents a form with the required fields
  above, and the form can't be submitted with any of them empty.

### Modified Capabilities

None.

## Impact

- New files under `.github/ISSUE_TEMPLATE/` and `.github/`.
- No existing workflow, code, or CI behavior changes.
