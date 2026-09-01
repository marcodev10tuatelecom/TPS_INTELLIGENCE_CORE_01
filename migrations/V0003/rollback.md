# TPSDBCORE01 V0003 Rollback

V0003 is **not deployed by this repository commit**. This document defines rollback authority only.

## Before any business use

If V0003 was deployed but no programming-rule profiles, rating-dependent approvals or commercial decisions were committed, rollback order is:

1. disable/drop `TRG_TPS_SCHEDULE_POLICY_GUARD`;
2. drop `TPS_PROGRAMMING_RULES_PKG` body/spec;
3. drop `TPS_COMMERCIAL_PKG` body/spec;
4. drop `TPS_PROGRAMMING_RULE_PROFILE` after confirming zero operational rows;
5. drop `TPS_CONTENT_RATING` after confirming no certified process depends on it.

Do not execute these steps from this document automatically.

## After operational use

Once schedules have been approved/activated using V0003 policy, or commercial placements have been authorized using `TPS_COMMERCIAL_PKG`, destructive rollback is **R3_TRANSFORMATIVE**.

Required approach:

- preserve decision/audit evidence;
- stop new V0003 state transitions;
- deploy a forward-compatible replacement or restore from an approved recovery point;
- never delete policy/decision history merely to make rollback easy.

## Evidence required

Rollback is complete only after:

- target objects have expected status;
- schedule states and placement states are reconciled;
- no invalid dependent objects remain in `USER_OBJECTS`/`USER_ERRORS`;
- recovery evidence is attached to the change record.
