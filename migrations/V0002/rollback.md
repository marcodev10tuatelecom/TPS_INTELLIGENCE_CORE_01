# V0002 — Rollback / Recovery Strategy

## Production rule

Do **not** execute blind DROP statements as an automatic rollback after the new objects have been used.

V0002 contains both additive schema objects and stateful authorization/audit data. Rollback therefore depends on deployment phase.

## Phase A — compile failed before runtime use

If the migration creates objects but postcheck fails before any application/agent/playout use, the preferred recovery is:

1. capture `USER_ERRORS`, object status and migration evidence;
2. correct source in Git;
3. re-run `CREATE OR REPLACE` for package/trigger objects where safe;
4. drop/recreate only newly introduced tables if they are confirmed empty and the change gate authorizes it.

Potential pre-use drop order, for an explicitly approved rollback only:

```text
TPS_AI_PROGRAMMING_TOOL_PKG body/spec
TPS_CONTINUITY_PKG body/spec
TRG_TPS_CONT_DECISION_IMMUTABLE
TPS_CONTINUITY_DECISION
TPS_PROGRAMMING_PKG body/spec
TPS_AI_GUARD_PKG body/spec
TPS_AI_AGENT_TOOL
```

The canonical `TPS_PROGRAMMING_TOOL` row must not be blindly deleted if any agent grant or audit row references it.

## Phase B — runtime used but no committed business history

If a controlled test transaction used the objects and fully rolled back, treat recovery as Phase A after proving tables are empty and no external consumer depends on the API.

## Phase C — committed programming/continuity/AI history exists

This is **not** a DROP rollback.

Required strategy:

- disable/revoke runtime EXECUTE grants first;
- suspend relevant AI agent/tool grants;
- stop new calls at the control-plane edge;
- preserve `TPS_CONTINUITY_DECISION` and `TPS_AI_DECISION` evidence;
- preserve schedule/item identities and lifecycle history;
- deploy a forward corrective migration or restore from certified recovery evidence if data corruption occurred;
- do not update/delete continuity ledger rows to disguise prior decisions.

## Transaction note

Oracle DDL carries implicit commit semantics. `WHENEVER SQLERROR ... ROLLBACK` in `apply.sql` cannot undo successfully completed earlier DDL statements. This is why migration recovery is object-by-object and evidence-driven rather than described as a magically atomic DDL transaction.

## Required evidence

Any production rollback/recovery must retain:

- before/after object inventory;
- `USER_ERRORS` output;
- migration commit SHA;
- timestamps/user/session;
- row counts for new stateful tables;
- grant/role state;
- reason for rollback;
- exact corrective migration or restore evidence.
