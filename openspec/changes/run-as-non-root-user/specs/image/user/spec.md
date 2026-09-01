## Purpose

Stops a compromised deploy job starting with root inside the container -
a non-root process begins with zero Linux capabilities, so privilege
escalation needs a kernel bug even before anything drops capabilities at
runtime.

## ADDED Requirements

### Requirement: Image runs as a non-root user
The published image SHALL run its default process as a non-root user with
a numeric UID and GID, and SHALL set `HOME` to that user's home directory
so shell `~` expansion resolves without depending on `/etc/passwd`
lookups.

#### Scenario: Default process identity
- **WHEN** the image runs with no overriding `--user` flag
- **THEN** `id` reports a non-zero UID and GID

#### Scenario: HOME resolves for shell expansion
- **WHEN** the image runs and a shell expands `$HOME` or `~`
- **THEN** it resolves to the non-root user's home directory, not `/root`

### Requirement: Shipped SSH config is owned by the runtime user
The shipped `~/.ssh/config` SHALL be owned by the non-root user, with the
`.ssh` directory at `700` and the config file at `600`.

#### Scenario: Config ownership and permissions
- **WHEN** the image is inspected
- **THEN** `~/.ssh` is mode `700` and `~/.ssh/config` is mode `600`, both
  owned by the non-root user
