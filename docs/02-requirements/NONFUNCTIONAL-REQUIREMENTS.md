# Nonfunctional Requirements

- NFR-001 Integrity: relational constraints protect canonical keys and references.
- NFR-002 Availability: metadata/Core failure must not unnecessarily terminate already-established media delivery; application design provides graceful degradation.
- NFR-003 Security: least privilege, encrypted transport, no DBA credentials in apps.
- NFR-004 Auditability: material decisions and privileged changes traceable.
- NFR-005 Explainability: D3KA/AI decisions expose evidence and policy chain.
- NFR-006 Scalability: logical model survives growth from current stations to larger networks without per-station schema duplication.
- NFR-007 Portability: source remains migration-capable to paid Autonomous capacity or compatible Oracle 26ai target.
- NFR-008 Maintainability: migration/version ledger and modular source tree.
- NFR-009 Observability: health, latency, errors, workload and AI cost/quality measurable.
- NFR-010 Recoverability: restore/rebuild must be tested, not inferred from backup existence.
