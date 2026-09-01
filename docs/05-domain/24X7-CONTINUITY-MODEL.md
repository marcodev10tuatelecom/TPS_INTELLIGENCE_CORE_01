# 24x7 Broadcast Continuity Model v0.01

The database is the canonical programming/fallback authority; streaming/playout execution may run on external media systems.

## Resolution order

At a given channel/time, `TPS_SCHEDULE_PKG.resolve_current_item` evaluates active schedule candidates through the D3KA owner chain `CHANNEL -> STATION -> NETWORK` and applies deterministic class precedence:

`EMERGENCY > LOCAL_OVERRIDE > CHANNEL > STATION > NETWORK > FALLBACK`, then explicit schedule precedence, hierarchy depth, item priority and stable ID.

## Requirement

An operational channel is certifiable for a coverage window only if every instant in the required window resolves to one authorized item after precedence and rights/policy evaluation. `TPS_SCHEDULE_GAP_V` detects gaps inside individual schedules; cross-schedule final coverage is tested through the resolver.

## Local studio outage

A local studio disconnect must not erase programming authority. If a local/live item becomes unavailable, the operational execution layer reports an event and selects an already-authorized fallback according to continuity policy. The database records schedule/fallback relationships and observed failover/recovery events.

## Safety

An item resolved by time/precedence is still not automatically playable if rights/policy evaluation denies it. Execution requires both schedule resolution and protected-action authorization.
