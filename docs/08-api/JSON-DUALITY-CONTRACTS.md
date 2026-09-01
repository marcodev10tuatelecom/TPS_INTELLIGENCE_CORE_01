# JSON Relational Duality Contracts v0.01

JSON Relational Duality is used selectively when an application benefits from document-shaped access while the same relational rows remain authoritative.

## Suitable projections
Entity profile, station/channel topology, program metadata, media metadata and bounded schedule views.

## Avoid
Do not hide broad graph traversal, high-volume event history or complex rights evaluation behind a giant mutable document. Those remain purpose-built query/package/API operations.

## Contract governance
Every duality view documents root keys, nested entities, updateability, concurrency rules, validation schema, security classification and backward compatibility. A duality document is a projection of the same relational truth, not a second database.
