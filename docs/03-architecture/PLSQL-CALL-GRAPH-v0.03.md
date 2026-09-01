# TPSDBCORE01 — PL/SQL CALL GRAPH v0.03

## Programming write path

```text
HUMAN/API/AI
    |
    +-- TPS_PROGRAMMING_PKG.CREATE_SCHEDULE
    |       -> TPS_SCHEDULE[DRAFT]
    |
    +-- TPS_PROGRAMMING_PKG.ADD_SCHEDULE_ITEM
    |       -> SELECT TPS_SCHEDULE FOR UPDATE
    |       -> active content
    |       -> no overlap
    |       -> active media asset unless LIVE
    |       -> TPS_RIGHTS_PKG.DECISION_FOR(...,'BROADCAST',...)
    |       -> TPS_SCHEDULE_ITEM
    |
    +-- TPS_PROGRAMMING_PKG.APPROVE_SCHEDULE
            -> base validation
            -> UPDATE TPS_SCHEDULE state=APPROVED
                    |
                    +-- TRG_TPS_SCHEDULE_POLICY_GUARD [AFTER STATEMENT]
                            -> TPS_PROGRAMMING_RULES_PKG.ASSERT_SCHEDULE_RULES
                                    -> SCHEDULE_REPORT
                                    |    -> REPEAT_VIOLATION_COUNT
                                    |    -> media duration match
                                    |    -> content rating lookup
                                    |    -> commercial rolling-hour load
                                    |    -> authorized placement check
                                    |
                                    +-- invalid -> -20601 -> state update rejected
```

## Commercial authorization path

```text
TPS_COMMERCIAL_PKG.AUTHORIZE_PLACEMENT
    -> SELECT TPS_PLACEMENT FOR UPDATE
    -> PLACEMENT_DECISION
         -> TPS_CAMPAIGN ACTIVE + valid time
         -> active TPS_MEDIA_ASSET for creative
         -> TPS_RIGHTS_PKG.DECISION_FOR(creative,channel,'BROADCAST',time)
         -> campaign frequency-window count
    -> ALLOW
         -> TPS_PLACEMENT.AUTHORIZED
       else
         -> TPS_PLACEMENT.REJECTED
```

## AI bounded programming path

```text
TPS_AI_PROGRAMMING_TOOL_PKG.EXECUTE_BOUNDED_ADD_ITEM
    -> TPS_AI_GUARD_PKG.ASSERT_PERMISSION
         -> active AI agent
         -> active tool
         -> active time-valid TPS_AI_AGENT_TOOL grant
         -> BOUNDED_AUTOMATION required
    -> SAVEPOINT
    -> TPS_PROGRAMMING_PKG.ADD_SCHEDULE_ITEM
    -> TPS_AI_DECISION success row
    -> error anywhere => ROLLBACK TO SAVEPOINT + re-raise
```

An AI insertion may enter a DRAFT schedule, but schedule approval/activation still passes through the database trigger and `TPS_PROGRAMMING_RULES_PKG`. Therefore bounded AI cannot bypass extended schedule policy.

## Continuity path

```text
TPS_CONTINUITY_PKG.RESOLVE_PLAYOUT
    -> local normal candidate
    -> local emergency
    -> local fallback
    -> D3KA relation: REPEATS / AFFILIATED_WITH
    -> network schedule
    -> network fallback
    -> NO_PLAYABLE_ITEM
    -> TPS_CONTINUITY_DECISION
         -> immutable UPDATE/DELETE trigger
```

## Hard rules implemented by v0.03 source

| Rule | Source authority | Enforcement point |
|---|---|---|
| Schedule item overlap | `TPS_PROGRAMMING_PKG` | item insertion |
| File asset required | `TPS_PROGRAMMING_PKG` | item insertion/base approval |
| Broadcast rights ALLOW | `TPS_RIGHTS_PKG` via programming/commercial packages | insert/authorization |
| Content repeat window | `TPS_PROGRAMMING_RULE_PROFILE` + `TPS_PROGRAMMING_RULES_PKG` | APPROVED/ACTIVE transition |
| Commercial rolling-hour seconds | same | APPROVED/ACTIVE transition |
| Program age classification | `TPS_CONTENT_RATING` + profile | APPROVED/ACTIVE transition |
| Asset duration tolerance | media asset + profile | APPROVED/ACTIVE transition |
| Commercial placement required | placement + profile | APPROVED/ACTIVE transition |
| Campaign validity | `TPS_COMMERCIAL_PKG` | placement authorization |
| Campaign frequency limit | `TPS_COMMERCIAL_PKG` | placement authorization |
| Continuity ledger immutable | trigger | UPDATE/DELETE |
| Schedule hard-policy bypass prevention | compound trigger | state transition |

## Runtime proof state

All objects above are repository source. Runtime compilation and execution in `TPSDBCORE01` remain separate evidence gates:

```text
SOURCE_BUILT=YES
RUNTIME_COMPILE=NOT_PROVEN
RUNTIME_FUNCTIONAL_TEST=NOT_RUN
```
