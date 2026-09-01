# TPSDBCORE01 — V0003 Programming Rules + Commercial Authorization

## Scope

V0003 is the next production change unit after V0002. It adds executable deterministic broadcaster rules, not AI prompt rules.

### New objects

- `TPS_CONTENT_RATING`
- `TPS_PROGRAMMING_RULE_PROFILE`
- `TPS_COMMERCIAL_PKG`
- `TPS_PROGRAMMING_RULES_PKG`
- `TRG_TPS_SCHEDULE_POLICY_GUARD`
- Brazilian content-rating seed rows

### Enforced capabilities

- repeat-window detection;
- maximum commercial seconds per rolling hour;
- maximum content minimum-age classification;
- required program classification;
- active media duration matching within tolerance;
- commercial placement authorization requirement;
- campaign/time/frequency/rights/asset checks for placements;
- database-level blocking of invalid schedule transition to `APPROVED` or `ACTIVE`.

## Execution order

```text
precheck.sql
  -> explicit approval
apply.sql
  -> postcheck.sql / COMP-002
  -> explicit rollback-only test approval
PRG-910_rules_engine.sql
```

## Production state

Repository source only. Nothing in V0003 is deployed merely because these files exist.

## PASS criteria

```text
V0003_PRECHECK=PASS
COMP-002=PASS
PRG-910=PASS
USER_ERRORS=0 for V0003 packages/trigger
```

## Known boundaries

- classification seed/reference still requires governance/legal review for authoritative regulatory use;
- commercial competitor-category conflict is not yet implemented;
- local/network percentage quotas are not yet implemented;
- territory/context rights enforcement remains blocked by the earlier rights-engine limitation;
- runtime privileges must later prevent ordinary direct DML around package boundaries.
