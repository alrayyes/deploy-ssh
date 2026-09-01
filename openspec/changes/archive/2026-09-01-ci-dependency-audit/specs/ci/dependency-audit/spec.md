## Purpose

Catches a pinned dependency that had no known vulnerability when it landed
but has one now, separately from whatever raises the update pull request.

## ADDED Requirements

### Requirement: CI audits bun dependencies for known vulnerabilities
The CI pipeline SHALL run `bun audit` on every push and every pull request,
and SHALL fail the job when `bun audit` reports a vulnerability.

#### Scenario: Clean dependency tree
- **WHEN** a push or pull request runs CI and `bun audit` finds no known
  vulnerabilities
- **THEN** the audit job passes

#### Scenario: Vulnerable dependency pinned
- **WHEN** a push or pull request runs CI and a pinned devDependency has a
  known vulnerability
- **THEN** the audit job fails, separately from the lint job
