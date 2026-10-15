## MODIFIED Requirements

### Requirement: CI audits bun dependencies for known vulnerabilities
The CI pipeline SHALL run `bun audit` on a pull request that changes
`package.json` or `bun.lock` and on every push to the default branch, and
SHALL fail the job only on advisories that the change introduces over its
base. No audit command, hook or script SHALL ignore an advisory.

#### Scenario: Clean dependency tree
- **WHEN** a pull request changes `bun.lock` and `bun audit` finds no known
  vulnerabilities
- **THEN** the audit job passes

#### Scenario: Pull request introduces a vulnerable dependency
- **WHEN** a pull request adds or bumps a pinned dependency to a version with
  a known vulnerability the base didn't have
- **THEN** the audit job fails, separately from the lint job

#### Scenario: Advisory already on the default branch
- **WHEN** a pull request changes `bun.lock` and the only advisories `bun audit`
  reports are ones the base already has
- **THEN** the audit job passes

#### Scenario: Pull request touches neither file
- **WHEN** a pull request changes neither `package.json` nor `bun.lock`
- **THEN** the audit job passes without running the audit

## ADDED Requirements

### Requirement: A scan of the default branch keeps one advisory ticket
A scheduled scan SHALL run `bun audit` on the default branch daily, on every
push that changes `package.json` or `bun.lock`, and on demand, and SHALL keep
exactly one open issue titled `Dependency advisories` that lists the advisories
found.

#### Scenario: Advisories found
- **WHEN** the scan finds advisories and no ticket is open
- **THEN** it opens one, and updates it when the list changes

#### Scenario: Audit clean
- **WHEN** the scan finds no advisories and a ticket is open
- **THEN** it comments and closes the ticket

#### Scenario: Audit errors
- **WHEN** the audit fails without naming an advisory, as when the registry is down
- **THEN** the job fails and leaves the ticket alone
