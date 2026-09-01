# TPSDBCORE01 — ENGINEERING STATE LEDGER v0.04

## 1. Purpose

This ledger separates repository engineering state from actual production Oracle runtime state. It is the authority to consult before claiming that something is built, deployed, compiled, tested or certified.

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
DATABASE_PRODUCTION_CLASSIFICATION=CONFIRMED
DATABASE_CURRENT_TIER=ALWAYS_FREE
FULL_SOURCE_CHAIN=V0001->V0002->V0003->V0004
FULL_BUILD_RUNNER=migrations/FULL/run_from_empty.sql
FULL_TEST_RUNNER=migrations/FULL/test_all.sql
RUNTIME_STATE_DETECTOR=migrations/FULL/runtime_state.sql
V0001_DEPLOYMENT=NOT_PROVEN
V0002_DEPLOYMENT=NOT_PROVEN
V0003_DEPLOYMENT=NOT_PROVEN
V0004_DEPLOYMENT=NOT_PROVEN
ORACLE_RUNTIME_COMPILE=NOT_PROVEN
FUNCTIONAL_RUNTIME_PRG900=NOT_RUN
FUNCTIONAL_RUNTIME_PRG910=NOT_RUN
FUNCTIONAL_RUNTIME_INT010=NOT_RUN
PRODUCTION_CERTIFICATION=BLOCKED
```

Repository file presence never proves Oracle deployment.

## 4. Durable recovery/documentation authority

- `CANONICAL-PROJECT-MANUAL-v0.03.md`
- `docs/00-governance/NAMING-AND-IDENTITY-REGISTER-v0.03.md`
- `docs/00-governance/PROJECT-RECOVERY-RUNBOOK-v0.03.md`
- `docs/15-evidence/ENGINEERING-STATE-LEDGER-v0.03.md` (this path, content v0.04)
- `docs/06-data-dictionary/SOURCE-ROUTINE-DEPENDENCY-CATALOG-v0.03.md`
- `docs/15-evidence/V0004-FUNCTIONAL-BROADCAST-CORE-STATE-v0.04.md`
- `PROJECT-MAP.md`
- `DOCUMENTATION-MAP.md`
- `SOURCE-MAP.md`
- `TRACEABILITY-MAP.md`

## 5. Migration state

### V0001 — Canonical Kernel Bootstrap

```text
PRECHECK=FAIL_CLOSED_READ_ONLY
APPLY=EXISTS
POSTCHECK=COMP-000
RUNNER=migrations/V0001/run.sql
PRE_DATA_ROLLBACK=migrations/V0001/rollback.sql
RUNTIME=NOT_PROVEN
```

V0001 precheck now refuses bootstrap when representative canonical core objects already exist.

### V0002 — Programming + AI Capability Guard + 24x7 Continuity

```text
PRECHECK=EXISTS
APPLY=EXISTS
POSTCHECK=COMP-001_programming_continuity.sql
RUNNER=migrations/V0002/run.sql
FUNCTIONAL_RUNNER=migrations/V0002/test.sql
FUNCTIONAL_TEST=PRG-900_vertical_plsql_slice.sql
RUNTIME=NOT_PROVEN
```

### V0003 — Programming Rules + Commercial Authorization

```text
PRECHECK=EXISTS
APPLY=EXISTS
POSTCHECK=COMP-002_programming_rules_commercial.sql
RUNNER=migrations/V0003/run.sql
FUNCTIONAL_RUNNER=migrations/V0003/test.sql
FUNCTIONAL_TEST=PRG-910_rules_engine.sql
RUNTIME=NOT_PROVEN
```

### V0004 — Broadcast Administration + Rights Administration + Playout API

```text
PRECHECK=FAIL_CLOSED_READ_ONLY
APPLY=EXISTS
POSTCHECK=COMP-003_broadcast_admin_playout.sql
RUNNER=migrations/V0004/run.sql
FUNCTIONAL_RUNNER=migrations/V0004/test.sql
FUNCTIONAL_TEST=INT-010_broadcast_end_to_end.sql
RUNTIME=NOT_PROVEN
```

V0004 adds actual operational PL/SQL APIs:

```text
TPS_BROADCAST_ADMIN_PKG
  ENSURE_ENTITY
  REGISTER_NETWORK
  REGISTER_STATION
  REGISTER_CHANNEL
  REGISTER_PROGRAM
  AFFILIATE_STATION
  REGISTER_MEDIA_ASSET

TPS_RIGHTS_ADMIN_PKG
  GRANT_RIGHT
  REVOKE_RIGHT

TPS_PLAYOUT_API_PKG
  NOW_NEXT_JSON
  RESOLVE_PLAYOUT_JSON
```

## 6. Functional source path now represented

```text
ADMIN
 -> canonical network/station/channel/program/entity creation
 -> D3KA AFFILIATED_WITH relation
 -> media-asset registration
 -> provenance-backed BROADCAST right
 -> deterministic programming rule profile
 -> schedule create/add/approve/activate
 -> now/next JSON
 -> affiliate primary-source failure
 -> deterministic continuity lookup
 -> D3KA affiliate -> network
 -> NETWORK_SCHEDULE fallback
 -> immutable continuity decision
```

`INT-010` exercises that full path with synthetic data and rolls all test DML back.

## 7. Runtime state discovery rule

Before selecting any production migration, run only:

```text
migrations/FULL/runtime_state.sql
```

It reads `USER_OBJECTS`, `USER_ERRORS` and `SYS_CONTEXT` only and emits:

```text
TPS_OBJECT_COUNT
V0001_CORE_VALID
V0002_VALID
V0003_VALID
V0004_VALID
INVALID_TPS_OBJECTS
TPS_USER_ERRORS
NEXT_ACTION
RUNTIME_STATE=PASS_READ_ONLY
```

Possible `NEXT_ACTION` states:

- `EMPTY_SCHEMA_CANDIDATE_FOR_V0001`
- `PARTIAL_OR_UNKNOWN_CORE_RECONCILIATION_REQUIRED`
- `V0002_CANDIDATE_AFTER_PRECHECK`
- `V0003_CANDIDATE_AFTER_PRECHECK`
- `V0004_CANDIDATE_AFTER_PRECHECK`
- `V0001_TO_V0004_PRESENT_RUN_FULL_TESTS`

No migration is selected from repository assumptions.

## 8. Known blockers after source construction

- runtime Oracle state has not yet been collected in this session;
- no retained actual `USER_ERRORS=0` evidence for V0001..V0004;
- PRG-900, PRG-910 and INT-010 have not yet run on TPSDBCORE01;
- rights territory/context enforcement remains incomplete in the existing rights decision package;
- generic TPS_POLICY/TPS_RULE evaluator is not yet a complete final authorization engine;
- runtime roles/grants preventing direct DML are not certified;
- request/retry idempotency ledger remains to be implemented;
- performance/concurrency/recovery tests remain required;
- D3KA weighted/per-domain >=90% certification remains incomplete;
- Graph/VECTOR/AI runtime capability still requires actual Oracle evidence.

## 9. Immediate recovery-safe sequence

```text
1. RUN migrations/FULL/runtime_state.sql        [READ ONLY]
2. retain complete output
3. reconcile partial/unknown state if detected
4. run only the next migration PRECHECK         [READ ONLY]
5. inspect precheck output
6. explicit production mutation decision
7. run selected migration runner
8. retain compile/user_errors evidence
9. run its rollback-only functional test
10. continue sequentially
```

No PASS may be inferred from this ledger or a chat response; runtime output is mandatory.
