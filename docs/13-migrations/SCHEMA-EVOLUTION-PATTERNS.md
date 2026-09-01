# Schema Evolution Patterns

Prefer additive expand/contract changes: add new nullable/object version -> dual-read/write or backfill where required -> validate -> switch projection/consumer -> retire old path later.

Canonical IDs and relation taxonomies are stable. Renames generally use new display metadata or compatibility view rather than destructive key changes.

Large table transforms, vector dimension/model transitions and API contract changes require explicit migration/backfill and rollback/forward-correction plans.
