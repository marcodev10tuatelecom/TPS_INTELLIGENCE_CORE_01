# BACKUP, RECOVERY & MIGRATION MASTER v0.02

## 1. Production premise

TPSDBCORE01 is production. Current Always Free capabilities define present operational constraints; they do not remove recovery obligations.

## 2. Recovery layers

R-L0 Source reconstruction: repository contains versioned schema/source/migrations.  
R-L1 Reference/seed reconstruction: controlled vocabularies and synthetic/reference seed can be rebuilt.  
R-L2 Logical data export: production logical data export strategy appropriate to service capabilities.  
R-L3 Native service backup/restore: used where supported and verified.  
R-L4 Clone/migration: migration to paid/new service used for capacity, recovery or architecture evolution where required.

No layer alone is assumed sufficient without tested recovery.

## 3. Data recovery classes

A — canonical identity/relation/history: strongest preservation; loss may corrupt corporate knowledge.  
B — contracts/rights/commercial decisions: legally/business critical.  
C — schedules/programming/event history: operationally critical.  
D — AI decisions/assertions/vectors: reproducibility/traceability critical; some vectors may be regenerable if source/model version preserved.  
E — caches/read models: rebuildable.  
F — synthetic fixtures: repository-controlled.

## 4. RPO/RTO

Exact RPO/RTO values are not invented. They are business requirements to be approved per class and then tested. Until approved, recovery status remains UNKNOWN/NOT CERTIFIED.

## 5. Export design

Logical exports must:
- exclude secrets;
- record database/schema/release identifiers;
- preserve canonical IDs;
- preserve temporal/provenance/audit relationships;
- checksum artifacts;
- encrypt and control access outside Git;
- produce export manifest and row-count/object inventory;
- support import validation.

## 6. Rebuild design

A clean rebuild follows:
1. provision/identify target Oracle service;
2. verify 26ai capabilities;
3. apply security/bootstrap;
4. apply ordered immutable schema migrations;
5. create D3KA/graph/vector/AI objects in certified order;
6. import canonical data;
7. validate counts/checksums/invariants;
8. rebuild derived vectors/read models/indexes as applicable;
9. execute complete certification suite;
10. authorize cutover only on PASS.

## 7. Migration to paid capacity

Promotion/migration is capacity/infrastructure evolution, not redesign of business identity. Before any tier change:
- capture AS-IS control plane;
- confirm supported promotion/migration behavior from current Oracle documentation;
- inventory feature differences;
- capture performance baseline;
- preserve wallet/connection transition plan;
- validate post-change service identity and capabilities;
- run graph/vector/AI/performance/security regression.

## 8. Migration source policy

Production migrations are immutable after deployment. Corrections use new migrations. Each migration declares dependencies, expected object/data diff, locking/duration, rollback/recovery class, tests and evidence.

## 9. Destructive changes

DROP, irreversible data transform, key changes, identity merge/split and history rewrites are R3/R4 and require explicit exceptional approval plus proven recovery strategy. AI never authorizes destructive migrations.

## 10. Recovery drills

Required drills include:
- source-only schema rebuild;
- logical export/import validation;
- D3KA invariant reconciliation after import;
- graph reconstruction and query parity;
- vector rebuild/lineage validation;
- API/read-model reconstruction;
- migration failure and compensating path;
- tier migration rehearsal when feasible.

## 11. Evidence

Every recovery drill produces run ID, source commit, export/import manifest, object inventory, row counts, D3KA health, graph parity, vector status, test results, elapsed time and checksum.

## 12. CORE-19

CORE-19 cannot PASS on the basis of 'backup enabled'. It requires demonstrated recovery/rebuild compatible with approved RPO/RTO and production criticality.