# ADR-0003 — One Relational Authority with Convergent Projections

Status: ACCEPTED.

Decision: authoritative state is persisted once in the canonical relational model. Property Graph, JSON Relational Duality and vector/AI layers project/enrich that authority rather than creating independent competing truth stores.

Consequence: apps consume controlled projections/APIs; duplicate per-app business databases are deprecated unless a documented bounded cache/read replica is explicitly non-authoritative.
