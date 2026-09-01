## Purpose

Gives anyone filing a bug report or feature request the same four-part
shape this project already requires of every issue, enforced by the form
itself rather than left to whoever remembers to write it by hand.

## ADDED Requirements

### Requirement: Bug reports use a structured form
Opening a new bug report through GitHub's issue picker SHALL present a form
requiring a description, reproduction steps, and expected behavior, and
SHALL NOT allow submission with any of those fields empty.

#### Scenario: Bug report submitted with all fields filled
- **WHEN** a contributor fills in description, reproduction steps, and
  expected behavior and submits the form
- **THEN** GitHub creates the issue

#### Scenario: Bug report missing a required field
- **WHEN** a contributor leaves the reproduction-steps field empty and
  tries to submit
- **THEN** GitHub blocks submission and highlights the missing field

### Requirement: Feature requests use a structured form
Opening a new feature request through GitHub's issue picker SHALL present a
form requiring a description (as a user story), acceptance criteria, and a
definition of done, and SHALL NOT allow submission with any of those fields
empty.

#### Scenario: Feature request submitted with all fields filled
- **WHEN** a contributor fills in the description, acceptance criteria, and
  definition of done and submits the form
- **THEN** GitHub creates the issue

### Requirement: Pull requests carry a terse template
Opening a new pull request SHALL pre-fill the description with a summary
section and a test-plan checklist, and nothing else.

#### Scenario: New pull request opened
- **WHEN** a contributor opens a new pull request through GitHub's compare
  view
- **THEN** the description field is pre-filled with the summary and
  test-plan checklist from `PULL_REQUEST_TEMPLATE.md`
