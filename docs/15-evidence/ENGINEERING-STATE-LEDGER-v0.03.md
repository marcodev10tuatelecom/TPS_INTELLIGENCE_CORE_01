# TPSDBCORE01 — ENGINEERING STATE LEDGER v0.03

## 1. Purpose

This ledger separates repository engineering state from actual production Oracle runtime state. It is the first document to consult before claiming that something is built, deployed, compiled, tested or certified.

## 2. Global identity

```text
REPOSITORY=TPS_INTELLIGENCE_CORE_01
DATABASE=TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
ENVIRONMENT=PRODUCTION
ORACLE_TARGET=Oracle AI Database 26ai
BRANCH=engineering-v0.02
```

## 3. Global state

```text
REPOSITORY_ENGINEERING=ACTIVE
CANONICAL_DOCUMENTATION=IN_RECONSTRUCTION_V0_03
DATABASE_PRODUCTION_CLASSIFICATION=CONFIRMED
DATABASE_CURRENT_TIER=ALWAYS_FREE
V0001_DEPLOYMENT=NOT_PROVEN / README STATES NOT_EXECUTED
V0002_DEPLOYMENT=NOT_RUN_BY_CURRENT_ENGINEERING_WORK
V0003_DEPLOYMENT=NOT_RUN_BY_CURRENT_ENGINEERING_WORK
ORACLE_RUNTIME_COMPILE_V0002=NOT_PROVEN
ORACLE_RUNTIME_COMPILE_V0003=NOT_PROVEN
FUNCTIONAL_RUNTIME_PRG900=NOT_RUN
FUNCTIONAL_RUNTIME_PRG910=NOT_RUN
PRODUCTION_CERTIFICATION=BLOCKED
```

The repository must never infer deployment from file presence.

## 4. Documentation state

### Durable recovery documents now present

- `CANONICAL-PROJECT-MANUAL-v0.03.md`
- `docs/00-governance/NAMING-AND-IDENTITY-REGISTER-v0.03.md`
- `docs/00-governance/PROJECT-RECOVERY-RUNBOOK-v0.03.md`
- `docs/15-evidence/ENGINEERING-STATE-LEDGER-v0.03.md`
- `docs/06-data-dictionary/SOURCE-ROUTINE-DEPENDENCY-CATALOG-v0.03.md`

### Existing project maps

- `PROJECT-MAP.md`
- `DOCUMENTATION-MAP.md`
- `SOURCE-MAP.md`
- `TRACEABILITY-MAP.md`

### Existing master specifications

- `docs/03-architecture/MASTER-DATABASE-ENGINEERING-SPEC-v0.02.md`
- `docs/04-d3ka/D3KA-ENGINEERING-SPEC-v0.02.md`
- `docs/07-ai-ml/AI-ML-RAG-AGENTS-MASTER-SPEC-v0.02.md`
- `docs/09-security/SECURITY-ARCHITECTURE-MASTER-v0.02.md`
- `docs/10-performance/PERFORMANCE-CAPACITY-MASTER-v0.02.md`
- `docs/11-testing/TEST-VALIDATION-CERTIFICATION-MASTER-v0.02.md`
- `docs/12-operations/BACKUP-RECOVERY-MIGRATION-MASTER-v0.02.md`
- `docs/03-architecture/PLSQL-CALL-GRAPH-v0.03.md`

### Documentation debt

An older source-documentation coverage document reports the baseline before later retrofit work and is no longer a reliable current percentage. It must be treated as historical until mechanically regenerated. The durable rule remains: each source is individually reviewed; no batch assumption of DOC_FULL.

## 5. Migration state

### V0001

```text
TITLE=Canonical Kernel Bootstrap
SOURCE=EXISTS
README_STATUS=DESIGN_COMPLETE_NOT_EXECUTED
RUNTIME=NOT_PROVEN
```

### V0002

```text
TITLE=Programming + AI Capability Guard + 24x7 Continuity
SOURCE=EXISTS
PRECHECK=EXISTS
APPLY=EXISTS
POSTCHECK=EXISTS
ROLLBACK_DOC=EXISTS
COMPILE_TEST=COMP-001_programming_continuity.sql
FUNCTIONAL_TEST=PRG-900_vertical_plsql_slice.sql
RUNTIME_DEPLOYED=NO_EVIDENCE
RUNTIME_COMPILED=NOT_PROVEN
FUNCTIONAL_PASS=NOT_PROVEN
```

### V0003

```text
TITLE=Programming Rules + Commercial Authorization
SOURCE=EXISTS
PRECHECK=EXISTS
APPLY=EXISTS
POSTCHECK=EXISTS
ROLLBACK_DOC=EXISTS
COMPILE_TEST=COMP-002_programming_rules_commercial.sql
FUNCTIONAL_TEST=PRG-910_rules_engine.sql
RUNTIME_DEPLOYED=NO_EVIDENCE
RUNTIME_COMPILED=NOT_PROVEN
FUNCTIONAL_PASS=NOT_PROVEN
```

## 6. Source-engineering capabilities already represented in Git

### Core identity / D3KA

- universal entity/type/property/source kernel;
- relation type and relation cell;
- D3KA package;
- projections/invariant checks;
- D3KA fact-class/mapping/coverage source;
- context;
- temporal package/current view;
- Property Graph source;
- VECTOR model/query source;
- assertions/provenance;
- events;
- policy/rule structures;
- AI model/agent/tool/decision structures.

### Business media domain

- station/channel/program/schedule/schedule item/media asset;
- rights grant and rights decision package;
- campaign/placement;
- audience/editorial projections;
- API/read-model sources;
- audit/migration/reference/index/certification sources.

### V0002 PL/SQL vertical slice

- AI capability guard;
- bounded AI programming tool;
- transactional programming engine;
- continuity decision ledger;
- continuity fallback engine;
- immutable continuity trigger.

### V0003 deterministic broadcaster rules

- content rating reference;
- temporal programming rule profiles;
- programming rules package;
- schedule policy guard trigger;
- commercial authorization package.

## 7. Runtime proof required before any PASS claim

For a deployed package/trigger/table to move from source-only to runtime-proven, retain:

1. migration/precheck output;
2. exact commit SHA/checksum;
3. object existence query;
4. `USER_OBJECTS.STATUS`;
5. zero relevant `USER_ERRORS`;
6. positive functional test output;
7. negative/fail-closed test output;
8. transaction/locking test where applicable;
9. privilege/security proof;
10. performance proof where applicable;
11. recovery/rollback evidence;
12. final gate decision.

## 8. Known blockers

- no current runtime compile evidence for new PL/SQL vertical slices;
- rights territory/context fields not yet fully evaluated in rights package;
- generic policy/rule table evaluator incomplete;
- direct-DML runtime privilege model not yet certified;
- AI/API retry idempotency not complete;
- continuity source-health integration incomplete;
- D3KA weighted/per-domain >=90% certification incomplete;
- Graph/VECTOR/AI actual production capability/runtime tests incomplete;
- performance and recovery certification incomplete;
- naming owner review pending for engineering-provisional identifiers;
- full source-by-source documentation audit still in progress.

## 9. Next recovery-safe sequence

```text
1. finish canonical documentation inventory
2. mechanically validate source documentation
3. owner review of provisional names and business terms
4. CORE-00/01 read-only production capability proof
5. reconcile V0001 dependency/deployment assumptions
6. only then consider controlled V0001/V0002/V0003 deployment order
7. compile/postcheck
8. rollback-only functional tests
9. security/performance/recovery evidence
10. gate certification
```

No later step may be marked PASS because a chat response says so.
