# Migration Strategy

Migrations are ordered, immutable and checksum-verified. Each migration declares reversibility class, preconditions, expected object state, forward SQL, validation and rollback/compensation/recovery.

Never edit an already-deployed migration to change history; create a new migration. The ledger links migration ID to Git commit and evidence.

Large/high-risk changes use expand-migrate-contract or blue-green/clone approaches when service tier supports them.
