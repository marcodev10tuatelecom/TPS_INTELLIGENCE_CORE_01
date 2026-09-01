# V0004 — Functional Broadcast Core Administration + Rights + Playout API

## Goal

Turn the existing kernel/programming/continuity architecture into an operable PL/SQL vertical slice:

```text
ADMIN
  -> TPS_BROADCAST_ADMIN_PKG
      -> TPS_ENTITY
      -> TPS_STATION / TPS_CHANNEL / TPS_PROGRAM / TPS_MEDIA_ASSET
      -> TPS_D3KA_PKG -> AFFILIATED_WITH

RIGHTS ADMIN
  -> TPS_RIGHTS_ADMIN_PKG
      -> TPS_RIGHT_GRANT
      -> TPS_RIGHTS_PKG

PROGRAMMING
  -> TPS_PROGRAMMING_PKG
      -> TPS_PROGRAMMING_RULES_PKG
      -> TPS_SCHEDULE / TPS_SCHEDULE_ITEM

PLAYOUT/API
  -> TPS_PLAYOUT_API_PKG
      -> TPS_PROGRAMMING_PKG current/next
      -> TPS_CONTINUITY_PKG
      -> affiliate -> network fallback
      -> JSON result
```

## New objects

- `TPS_BROADCAST_ADMIN_PKG` specification/body
- `TPS_RIGHTS_ADMIN_PKG` specification/body
- `TPS_PLAYOUT_API_PKG` specification/body

No new persistent table is introduced by V0004.

## Required previous state

V0004 assumes the kernel and V0002/V0003 objects already exist and are valid. `precheck.sql` verifies required tables/packages/reference rows.

## Execution

```text
precheck.sql
  -> explicit production change approval
apply.sql
  -> postcheck.sql
  -> COMP-003=PASS
  -> separate rollback-only test authorization
INT-010_broadcast_end_to_end.sql
```

## Functional proof

`tests/integration/INT-010_broadcast_end_to_end.sql` must prove, under SAVEPOINT/ROLLBACK:

1. network creation;
2. TV station creation;
3. channel creation;
4. program creation;
5. D3KA `AFFILIATED_WITH` relation;
6. media-asset registration;
7. provenance-backed `BROADCAST=ALLOW` right;
8. network schedule creation, item insertion, approval and activation;
9. `NOW/NEXT` JSON retrieval;
10. affiliate primary-source failure;
11. deterministic `NETWORK_SCHEDULE` continuity selection;
12. complete rollback of synthetic rows.

## PASS criteria

```text
V0004_PRECHECK=PASS
COMP-003=PASS
INT-010=PASS
USER_ERRORS=0 for all V0004 packages
```

## Current repository/runtime state

```text
SOURCE=BUILT
PRODUCTION_DEPLOYMENT=NOT_RUN_BY_THIS_COMMIT
RUNTIME_COMPILE=NOT_PROVEN
INT-010_RUNTIME=NOT_RUN
```
