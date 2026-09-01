# TPSDBCORE01 — PRODUCTION CHANGE CONTROL v0.01

## Classification

`TPSDBCORE01` / `TPS_INTELLIGENCE_CORE_01` is PRODUCTION. Always Free is its current tier, not an environment downgrade.

## Change classes

- C0 — read-only observation, no persistent state change.
- C1 — additive low-risk object/config change with verified recovery.
- C2 — state/data-impacting change with tested migration and recovery.
- C3 — high-risk/destructive/external behavior change requiring explicit authority, backup/restore or blue-green strategy.
- C4 — prohibited without exceptional executive/database authority (irreversible deletion or security bypass).

## Required production change record

Every mutation must state: change ID, reason, requirement/gate, exact objects, exact source commit, prerequisites, prechecks, blast radius, dependencies, security impact, performance impact, backup/recovery strategy, forward steps, post-checks, rollback/compensation, abort conditions, evidence locations and approval.

## Execution principles

- no ad-hoc SQL copied from chat into production;
- deploy immutable reviewed source revision;
- fail closed on wrong database/service/user;
- verify DB identity before mutation;
- use least privileged deployment authority;
- separate secret material from Git and logs;
- record UTC timestamps and checksums;
- do not combine unrelated changes;
- preserve audit/history;
- stop on unexpected state.

## Tier change/migration

Promotion from Always Free to paid or migration/clone is treated as capacity/infrastructure evolution. The canonical logical model and repository authority remain. Post-move certification must re-run connectivity, security, performance, backup/restore and feature compatibility gates.
