# TPS_INTELLIGENCE_CORE_01 — PROGRAMMING + AI + CONTINUITY PL/SQL ARCHITECTURE v0.02

## 1. Scope

This document describes the first **executable PL/SQL vertical slice** of the corporate media intelligence core.

It is not a conceptual pseudo-architecture. Every component named below maps to a source file in `src/` and a compile or behavioral test under `tests/`.

Database: `TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01`  
Environment: **PRODUCTION**  
Repository state: **SOURCE ONLY / NOT DEPLOYED** until an approved production migration is executed.

---

# 2. Runtime architecture

```text
                         HUMAN / API / ORACLE AI AGENT
                                   |
                  +----------------+----------------+
                  |                                 |
               HUMAN/API                         AI CALLER
                  |                                 |
                  |                       TPS_AI_PROGRAMMING_TOOL_PKG
                  |                                 |
                  |                         TPS_AI_GUARD_PKG
                  |                                 |
                  |                    TPS_AI_AGENT_TOOL permissions
                  |                                 |
                  +---------------+-----------------+
                                  |
                          TPS_PROGRAMMING_PKG
                                  |
              +-------------------+-------------------+
              |                   |                   |
       TPS_SCHEDULE       TPS_MEDIA_ASSET        TPS_RIGHTS_PKG
       TPS_SCHEDULE_ITEM                          TPS_RIGHT_GRANT
              |
              +-------------------+
                                  |
                           ACTIVE PROGRAMMING
                                  |
                         TPS_CONTINUITY_PKG
                                  |
             +--------------------+--------------------+
             |                    |                    |
        local current         EMERGENCY            FALLBACK
                                                       |
                                             D3KA parent lookup
                                                       |
                              TPS_RELATION + TPS_RELATION_TYPE
                                  REPEATS/AFFILIATED_WITH
                                                       |
                                               NETWORK schedule
                                                       |
                                      TPS_CONTINUITY_DECISION
                                                       |
                           immutable trigger prevents UPDATE/DELETE
```

---

# 3. Source files implemented in this vertical slice

## AI authorization and bounded tool execution

- `src/11-ai/1190_tps_ai_agent_tool.sql`
- `src/11-ai/1191_tps_ai_guard_pkg.pks`
- `src/11-ai/1192_tps_ai_guard_pkg.pkb`
- `src/11-ai/1193_tps_ai_programming_tool_pkg.pks`
- `src/11-ai/1194_tps_ai_programming_tool_pkg.pkb`

## Programming engine

- `src/12-media/1260_tps_programming_pkg.pks`
- `src/12-media/1261_tps_programming_pkg.pkb`

## Continuity engine

- `src/12-media/1270_tps_continuity_decision.sql`
- `src/12-media/1271_tps_continuity_decision_immutable_trg.sql`
- `src/12-media/1280_tps_continuity_pkg.pks`
- `src/12-media/1281_tps_continuity_pkg.pkb`

## Canonical capability reference

- `src/20-reference/2070_ai_tools.sql`

## Deployment/test controls

- `migrations/V0002/precheck.sql`
- `migrations/V0002/apply.sql`
- `migrations/V0002/postcheck.sql`
- `tests/compile/COMP-001_programming_continuity.sql`
- `tests/programming/PRG-900_vertical_plsql_slice.sql`

---

# 4. TPS_PROGRAMMING_PKG

## 4.1 Public API

```text
create_schedule(...)
    -> TPS_SCHEDULE DRAFT row

add_schedule_item(...)
    -> lock schedule row
    -> validate schedule lifecycle/time
    -> validate content identity
    -> reject time overlap
    -> validate active media asset unless LIVE
    -> rights decision_for(..., 'BROADCAST', item start)
    -> require ALLOW
    -> insert TPS_SCHEDULE_ITEM

validation_report(schedule_id)
    -> JSON validation report

approve_schedule(schedule_id)
    -> full validation
    -> DRAFT -> APPROVED

activate_schedule(schedule_id)
    -> full validation
    -> reject same owner/class active temporal collision
    -> APPROVED -> ACTIVE

item_is_playable(item_id, at)
    -> schedule/item lifecycle
    -> time containment
    -> asset availability
    -> rights ALLOW

current_item(owner, at)
    -> ordered current candidates
    -> first playable item

next_item(owner, after)
    -> ordered future candidates
    -> first playable item
```

## 4.2 Transaction rule

`TPS_PROGRAMMING_PKG` issues **no COMMIT** and **no global ROLLBACK**.

The caller controls transaction atomicity.

`ADD_SCHEDULE_ITEM` uses:

```sql
SELECT ...
FROM tps_schedule
WHERE schedule_id = :id
FOR UPDATE;
```

This serializes edits for a schedule before the overlap check and closes the classic race:

```text
session A checks empty interval
session B checks same empty interval
A inserts
B inserts
```

When all normal writes go through the package, B waits for A's lock before validating.

Direct schedule-table DML must therefore be removed from ordinary runtime roles.

---

# 5. Schedule lifecycle

```text
                CREATE_SCHEDULE
                      |
                      v
                   DRAFT
                      |
              validation clean
                      |
                      v
                  APPROVED
                      |
     no active same owner/class overlap
                      |
                      v
                   ACTIVE
                      |
                later lifecycle
                      v
             SUPERSEDED / RETIRED
```

Items use their own lifecycle:

```text
ACTIVE -> PLAYED
ACTIVE -> SKIPPED
ACTIVE -> CANCELLED
ACTIVE -> SUPERSEDED
```

The current package creates `ACTIVE` items inside a DRAFT schedule; schedule activation determines when those items become runtime candidates.

---

# 6. Validation engine

`VALIDATION_REPORT` currently emits JSON counts for:

```text
item_count
     |
     +-- must be > 0

overlap_count
     |
     +-- must be 0

out_of_window_count
     |
     +-- must be 0

missing_asset_count
     |
     +-- must be 0 except LIVE source semantics

rights_not_allowed_count
     |
     +-- must be 0
```

Example logical output:

```json
{
  "schedule_id": 123,
  "owner_entity_id": 456,
  "valid": 1,
  "item_count": 28,
  "overlap_count": 0,
  "out_of_window_count": 0,
  "missing_asset_count": 0,
  "rights_not_allowed_count": 0
}
```

This JSON is generated by Oracle `JSON_OBJECT`, not by application string concatenation.

---

# 7. Rights boundary

Programming does not interpret a missing grant as permission.

```text
TPS_RIGHTS_PKG.DECISION_FOR
        |
        +-- DENY    -> reject
        +-- UNKNOWN -> reject
        +-- ALLOW   -> continue validation
```

This means:

```text
UNKNOWN != ALLOW
```

Current known limitation: the existing rights package does not yet enforce its stored `territory_entity_id` and `context_id` fields. Therefore territorial/contextual rights remain a certification blocker even though the programming engine correctly calls the rights authority.

---

# 8. 24x7 continuity decision tree

`TPS_CONTINUITY_PKG.RESOLVE_PLAYOUT` is deterministic.

```text
INPUT:
  owner_entity_id
  primary_available = 0/1
  evaluation timestamp

                    START
                      |
          normal current schedule item?
                      |
       +--------------+--------------+
       |                             |
primary available?             primary unavailable?
       |                             |
 LIVE may be used               LIVE is skipped
       |                             |
       +--------------+--------------+
                      |
            playable local item?
                yes -> LOCAL_SCHEDULE / PRIMARY
                      |
                     no
                      v
              local EMERGENCY?
                yes -> LOCAL_EMERGENCY
                      |
                     no
                      v
               local FALLBACK?
                yes -> LOCAL_FALLBACK
                      |
                     no
                      v
        D3KA REPEATS / AFFILIATED_WITH
                      |
               parent network?
                      |
          +-----------+-----------+
          |                       |
     NETWORK current          NETWORK FALLBACK
          |                       |
 NETWORK_SCHEDULE         NETWORK_FALLBACK
          +-----------+-----------+
                      |
                 none available
                      |
              NO_PLAYABLE_ITEM
```

The engine never invents a content ID merely to avoid an empty result.

---

# 9. D3KA in runtime continuity

The parent network is not stored in a special procedural configuration table.

It is resolved from the corporate tensor/relationship model:

```text
S = affiliate/repeater owner entity
R = REPEATS or AFFILIATED_WITH
T = parent/network entity
```

Only relations satisfying current lifecycle/time semantics are considered:

```text
relation.state = ACTIVE
relation.valid_from <= evaluation time
relation.valid_to is open OR evaluation time < valid_to
relation_type.lifecycle_state = ACTIVE
target entity.state = ACTIVE
```

Selection priority currently favors:

```text
REPEATS
then AFFILIATED_WITH
then higher confidence
then lowest relation_id
```

This deterministic ordering must eventually be expanded for explicit network precedence when an entity legitimately participates in multiple networks.

---

# 10. Continuity decision ledger

Every call to `RESOLVE_PLAYOUT` inserts:

```text
owner_entity_id
network_entity_id
primary_available
evaluated_at
selected_schedule_item_id
decision_code
reason_json
created_at
created_by
```

Decision codes:

```text
PRIMARY
LOCAL_SCHEDULE
LOCAL_EMERGENCY
LOCAL_FALLBACK
NETWORK_SCHEDULE
NETWORK_FALLBACK
NO_PLAYABLE_ITEM
```

The trigger:

```text
TRG_TPS_CONT_DECISION_IMMUTABLE
```

raises `-20301` before any UPDATE or DELETE.

This is one of the few intentional trigger use cases in the architecture: **protecting an append-only evidence ledger**, not hiding business workflow.

---

# 11. AI authorization architecture

## 11.1 Agent declaration is not authority

`TPS_AI_AGENT.AUTHORITY_CLASS` contains:

```text
ANALYTICS_ONLY
ADVISORY
BOUNDED_AUTOMATION
```

but that value alone cannot authorize a tool.

## 11.2 Tool grant

`TPS_AI_AGENT_TOOL` adds the actual capability relation:

```text
AI_AGENT
  -> AI_TOOL
  -> PERMISSION_MODE
  -> TIME WINDOW
  -> STATE
```

Modes:

```text
READ
PROPOSE
EXECUTE_BOUNDED
```

## 11.3 Guard rules

`TPS_AI_GUARD_PKG` applies:

```text
agent exists
AND agent.state = ACTIVE
AND tool exists
AND tool.state = ACTIVE
AND active time-valid grant exists
AND authority class permits requested mode
```

Authority matrix:

| Agent authority | READ | PROPOSE | EXECUTE_BOUNDED |
|---|---:|---:|---:|
| ANALYTICS_ONLY | yes | no | no |
| ADVISORY | yes | yes | no |
| BOUNDED_AUTOMATION | yes | yes | yes |

Prompt wording is not checked because prompt wording is not a security control.

---

# 12. AI programming tool

Canonical tool key:

```text
TPS_PROGRAMMING_TOOL
```

PL/SQL API:

```text
context_snapshot(...)
    requires READ
    -> JSON current/next/network context

propose_schedule_item(...)
    requires PROPOSE
    -> TPS_AI_DECISION
    -> does NOT modify schedule

execute_bounded_add_item(...)
    requires EXECUTE_BOUNDED
    -> local SAVEPOINT
    -> TPS_PROGRAMMING_PKG.ADD_SCHEDULE_ITEM
    -> rights/asset/overlap validation
    -> TPS_AI_DECISION success record
    -> on any failure: ROLLBACK TO SAVEPOINT + re-raise
```

The critical invariant is physically represented in code:

```text
AI tool
   cannot INSERT directly into TPS_SCHEDULE_ITEM

AI tool
   must call TPS_PROGRAMMING_PKG

TPS_PROGRAMMING_PKG
   must pass deterministic rules
```

---

# 13. Local atomicity of bounded AI execution

A subtle transaction risk exists when a subprogram performs multiple DML statements and a later statement fails. Oracle PL/SQL does not promise to roll back all previous statements in a subprogram merely because an exception propagates.

Therefore `EXECUTE_BOUNDED_ADD_ITEM` explicitly uses:

```sql
SAVEPOINT tps_ai_bounded_exec;
```

and on any error:

```sql
ROLLBACK TO tps_ai_bounded_exec;
RAISE;
```

This protects the bounded operation while preserving any unrelated earlier work in the caller transaction.

The package still does not COMMIT; final commit authority remains outside the AI tool.

---

# 14. Compile and behavioral tests

## Compile gate

`tests/compile/COMP-001_programming_continuity.sql`

Checks:

- objects exist;
- `USER_OBJECTS.STATUS = VALID`;
- `USER_ERRORS` contains zero compiler errors.

## Vertical synthetic test

`tests/programming/PRG-900_vertical_plsql_slice.sql`

Under one rollback-only savepoint it tests:

1. synthetic entities/source/assets/rights;
2. schedule creation;
3. item insert;
4. overlap rejection `-20215`;
5. validation JSON;
6. approval/activation;
7. current item resolution;
8. rights fail-closed `-20217`;
9. D3KA parent-network relation;
10. network fallback when local LIVE primary is unavailable;
11. continuity decision logging;
12. immutable-ledger rejection `-20301`;
13. AI model/agent/tool permission;
14. `EXECUTE_BOUNDED` permission;
15. bounded AI schedule insertion;
16. successful AI decision ledger row;
17. rollback of all synthetic data.

This test is not automatically run by deployment because it performs temporary DML. It requires an explicit test gate.

---

# 15. Known incomplete areas

This slice is functional source architecture, not final certification. Remaining work includes:

1. Oracle runtime compile on TPSDBCORE01.
2. Runtime execution of `COMP-001`.
3. Explicitly authorized rollback-only execution of `PRG-900`.
4. Direct-DML privilege removal and package EXECUTE role design.
5. Request/correlation idempotency ledger for API/AI retries.
6. Source-health registry for local/network LIVE paths.
7. Territory/context enforcement in rights engine.
8. Full generic TPS_POLICY/TPS_RULE evaluation.
9. Commercial break/frequency/competitor rules.
10. Age/editorial/regulatory programming rules.
11. Schedule inheritance percentages and local override quotas.
12. Repeat-window rules (for example no episode repeat within N hours).
13. Minimum/maximum advertising minutes per clock hour.
14. Exact media-duration vs scheduled-duration validation.
15. Timezone/DST test suite.
16. High-concurrency schedule editing test.
17. Continuity decision retry/idempotency model.
18. Graph/vector candidate ranking for intelligent filler selection.
19. AI failure ledger for rejected bounded operations.
20. Recovery/restore and performance certification.

These are next engineering work items, not hidden assumptions.

---

# 16. Official Oracle technology basis

The slice deliberately uses native Oracle capabilities:

- PL/SQL packages and definer-rights execution;
- `SELECT ... FOR UPDATE` locking;
- SAVEPOINT / `ROLLBACK TO SAVEPOINT` transaction control;
- SQL/JSON `JSON_OBJECT`, including `RETURNING JSON` / `RETURNING CLOB`;
- constraints and indexes;
- SQL Property Graph / `GRAPH_TABLE` in the wider D3KA architecture;
- standard Oracle error signaling through `RAISE_APPLICATION_ERROR`.

Runtime compatibility still has to be proven on the actual production service before certification.
