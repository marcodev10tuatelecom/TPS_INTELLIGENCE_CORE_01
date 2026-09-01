# TPSDBCORE01 — PL/SQL VERTICAL SLICE COVERAGE v0.02

## 1. Scope

Evidence state for the Programming + AI Capability Guard + 24x7 Continuity vertical slice.

## 2. Repository state

```text
BRANCH                         engineering-v0.02
DATABASE                       TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
ENVIRONMENT                    PRODUCTION
SOURCE_BUILT                    YES
EMBEDDED_DOCUMENTATION          YES
MIGRATION_MANIFEST              YES
COMPILE_TEST_SOURCE             YES
ROLLBACK_ONLY_VERTICAL_TEST     YES
ORACLE_RUNTIME_DEPLOYED         NO
ORACLE_RUNTIME_COMPILED         NOT_PROVEN
ORACLE_USER_ERRORS_ZERO         NOT_PROVEN
FUNCTIONAL_TEST_EXECUTED        NO
PRODUCTION_CERTIFIED            NO
```

## 3. New database source artifacts

Twelve new executable/reference source artifacts were added by this vertical slice:

1. `src/11-ai/1190_tps_ai_agent_tool.sql`
2. `src/11-ai/1191_tps_ai_guard_pkg.pks`
3. `src/11-ai/1192_tps_ai_guard_pkg.pkb`
4. `src/11-ai/1193_tps_ai_programming_tool_pkg.pks`
5. `src/11-ai/1194_tps_ai_programming_tool_pkg.pkb`
6. `src/12-media/1260_tps_programming_pkg.pks`
7. `src/12-media/1261_tps_programming_pkg.pkb`
8. `src/12-media/1270_tps_continuity_decision.sql`
9. `src/12-media/1271_tps_continuity_decision_immutable_trg.sql`
10. `src/12-media/1280_tps_continuity_pkg.pks`
11. `src/12-media/1281_tps_continuity_pkg.pkb`
12. `src/20-reference/2070_ai_tools.sql`

Each has the v0.02 embedded documentation contract covering purpose, impact, dependencies, D3KA/AI role, security, performance, transaction, failure modes, recovery, tests, evidence and references. Package routines are documented individually.

## 4. Overall source-documentation count after this slice

The previous baseline recorded 84 source artifacts and 44 fully retrofitted embedded-documentation sources.

This slice adds 12 new sources, all authored with the full documentation contract from creation.

Therefore the current controlled count is:

```text
TOTAL_SOURCE_ARTIFACTS          96
DOC_FULL                        56
DOC_PARTIAL_OR_PENDING          40
DOC_FULL_PERCENT                58.33%
```

This is a documentation-coverage count, not production-validation coverage.

## 5. PL/SQL routines implemented

### TPS_PROGRAMMING_PKG

- `CREATE_SCHEDULE`
- `ADD_SCHEDULE_ITEM`
- `VALIDATION_REPORT`
- `APPROVE_SCHEDULE`
- `ACTIVATE_SCHEDULE`
- `ITEM_IS_PLAYABLE`
- `CURRENT_ITEM`
- `NEXT_ITEM`

### TPS_CONTINUITY_PKG

- `RESOLVE_NETWORK_ENTITY`
- `RESOLVE_PLAYOUT`

### TPS_AI_GUARD_PKG

- `PERMISSION_ALLOWED`
- `ASSERT_PERMISSION`

### TPS_AI_PROGRAMMING_TOOL_PKG

- `CONTEXT_SNAPSHOT`
- `PROPOSE_SCHEDULE_ITEM`
- `EXECUTE_BOUNDED_ADD_ITEM`

## 6. Trigger implemented

`TRG_TPS_CONT_DECISION_IMMUTABLE`

Purpose: reject UPDATE/DELETE of the append-only continuity decision ledger. It does not contain programming business logic.

## 7. Compile proof required

After an explicitly approved V0002 deployment, run:

`migrations/V0002/postcheck.sql`

which invokes:

`tests/compile/COMP-001_programming_continuity.sql`

Required evidence:

```text
all expected USER_OBJECTS rows exist
all statuses = VALID
USER_ERRORS count = 0
COMP-001=PASS
```

Until that output exists, no document may state that the package is compiled/working inside the production Oracle instance.

## 8. Functional proof required

After compile PASS and a separate rollback-only test authorization, execute:

`tests/programming/PRG-900_vertical_plsql_slice.sql`

Required expected output includes:

```text
PRG-900=PASS
CONTINUITY_DECISION=NETWORK_SCHEDULE
```

The test also proves expected rejection paths for overlap, missing rights and continuity-ledger mutation, then rolls all synthetic test DML back to its savepoint.

## 9. Certification state

```text
SOURCE_ENGINEERING             PASS
DOCUMENTATION_FOR_NEW_SOURCES PASS
DEPLOYMENT                    NOT_RUN
COMPILE_RUNTIME               NOT_PROVEN
FUNCTIONAL_RUNTIME            NOT_PROVEN
SECURITY_RUNTIME              NOT_PROVEN
PERFORMANCE_RUNTIME           NOT_PROVEN
RECOVERY_RUNTIME              NOT_PROVEN
PRODUCTION_CERTIFICATION      BLOCKED
```
