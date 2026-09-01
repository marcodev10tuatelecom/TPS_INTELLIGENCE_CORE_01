# TPS MEDIA API Architecture v0.01

## Principle
Applications consume versioned contracts, not the physical Oracle schema. ORDS or a controlled application service exposes approved projections/packages using a least-privilege API role.

## Resource families
- `/v1/entities/{id}` canonical identity/read projection;
- `/v1/entities/{id}/graph` authorized D3KA neighborhood;
- `/v1/networks`, `/stations`, `/channels` topology;
- `/v1/channels/{id}/now-programming` current authoritative schedule projection;
- `/v1/programs/{id}` program metadata;
- `/v1/media/{id}` content/asset metadata;
- `/v1/rights/evaluate` protected server-side policy endpoint;
- `/v1/recommendations/*` governed recommendation endpoints;
- `/v1/ai/explain/{decisionId}` evidence-aware AI explanation where authorized.

## Contract rules
- stable IDs and explicit versioning;
- pagination/cursors for collections;
- UTC/offset-aware ISO timestamps;
- ETag/version where optimistic concurrency is exposed;
- no raw owner-table access;
- explicit data-classification/redaction;
- correlation/request ID propagated to audit/AI decision logs;
- deterministic error codes separate technical failure from business denial.

## Mutation
Protected writes are mediated by packages/services that enforce D3KA invariants and policy. API permission never implies table-owner permission.
