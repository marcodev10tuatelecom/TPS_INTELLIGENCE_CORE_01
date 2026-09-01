# Versioning Policy

## Repository
Semantic release line: `MAJOR.MINOR.PATCH`. Schema migrations carry immutable sequence IDs and checksums.

## Database objects
Never infer deployed version from repository HEAD. Deployed state is recorded in a schema migration ledger containing migration ID, commit SHA, checksum, actor, UTC timestamps and outcome.

## Contracts
API/read-model contracts are versioned independently when backward compatibility requires it.

## AI artifacts
Model profiles, prompts, tools, agent cards and evaluation sets have immutable versions. Decisions record the exact versions used.

## Relation/entity taxonomies
Canonical keys are stable. Deprecation uses lifecycle state and replacement references; IDs are never recycled.
