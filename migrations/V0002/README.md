# V0002 — Programming + AI Capability Guard + 24x7 Continuity

## Classification

- Database: `TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01`
- Environment: **PRODUCTION**
- Current repository state: **SOURCE ONLY / NOT DEPLOYED**
- Migration class: mixed `R1_ADDITIVE` + `R2_STATEFUL reference configuration`
- Automatic execution: **PROHIBITED**

## Goal

Install the first end-to-end PL/SQL business vertical slice:

```text
AI AGENT
  -> TPS_AI_GUARD_PKG
      -> TPS_AI_PROGRAMMING_TOOL_PKG
          -> TPS_PROGRAMMING_PKG
              -> TPS_RIGHTS_PKG
              -> TPS_MEDIA_ASSET
              -> TPS_SCHEDULE / TPS_SCHEDULE_ITEM

PRIMARY SOURCE / PLAYOUT
  -> TPS_CONTINUITY_PKG
      -> local schedule
      -> emergency
      -> fallback
      -> D3KA REPEATS/AFFILIATED_WITH
      -> network schedule/fallback
      -> TPS_CONTINUITY_DECISION (immutable ledger)
```

## New schema objects

1. `TPS_AI_AGENT_TOOL` table + index
2. `TPS_AI_GUARD_PKG` spec/body
3. `TPS_PROGRAMMING_PKG` spec/body
4. `TPS_CONTINUITY_DECISION` table + index
5. `TRG_TPS_CONT_DECISION_IMMUTABLE`
6. `TPS_CONTINUITY_PKG` spec/body
7. `TPS_AI_PROGRAMMING_TOOL_PKG` spec/body
8. canonical reference row `TPS_PROGRAMMING_TOOL`

## Required pre-existing dependencies

- `TPS_ENTITY`
- `TPS_RELATION_TYPE`
- `TPS_RELATION`
- `TPS_SCHEDULE`
- `TPS_SCHEDULE_ITEM`
- `TPS_MEDIA_ASSET`
- `TPS_RIGHT_GRANT`
- `TPS_RIGHTS_PKG`
- `TPS_AI_MODEL`
- `TPS_AI_AGENT`
- `TPS_AI_TOOL`
- `TPS_AI_DECISION`

## Deployment order

`precheck.sql` must PASS before `apply.sql` is considered.

`apply.sql` intentionally orders objects so every PL/SQL body sees its dependencies.

`postcheck.sql` is read-only and must show all new PL/SQL objects `VALID` with zero `USER_ERRORS`.

The synthetic vertical test `tests/programming/PRG-900_vertical_plsql_slice.sql` is **not** executed automatically. It performs rollback-only DML and requires a separate explicit test gate.

## Certification blockers after compilation

Compilation alone is insufficient. Before production use:

- run concurrency test for schedule edit locking;
- run rights territory/context test after rights engine implements those dimensions;
- test source-health integration for network `LIVE` fallback;
- define request-id/idempotency ledger for retries;
- define runtime grants (`EXECUTE` packages, no direct DML);
- run bounded AI prompt/tool attack tests;
- benchmark current/next/continuity queries;
- run recovery/restore evidence for the new tables/ledger.
