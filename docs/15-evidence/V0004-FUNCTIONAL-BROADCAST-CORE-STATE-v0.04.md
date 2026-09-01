# TPSDBCORE01 — V0004 FUNCTIONAL BROADCAST CORE STATE v0.04

## Built source

V0004 adds executable PL/SQL contracts that make the existing canonical schema operable without direct ad-hoc DML:

- `TPS_BROADCAST_ADMIN_PKG`
  - `ENSURE_ENTITY`
  - `REGISTER_NETWORK`
  - `REGISTER_STATION`
  - `REGISTER_CHANNEL`
  - `REGISTER_PROGRAM`
  - `AFFILIATE_STATION`
  - `REGISTER_MEDIA_ASSET`
- `TPS_RIGHTS_ADMIN_PKG`
  - `GRANT_RIGHT`
  - `REVOKE_RIGHT`
- `TPS_PLAYOUT_API_PKG`
  - `NOW_NEXT_JSON`
  - `RESOLVE_PLAYOUT_JSON`

## End-to-end path

```text
register network/station/channel/program
  -> canonical TPS_ENTITY identities
  -> station/channel/program projections
  -> AFFILIATED_WITH through TPS_D3KA_PKG
  -> register playable media asset
  -> create provenance source
  -> GRANT_RIGHT(BROADCAST=ALLOW)
  -> create programming rule profile
  -> TPS_PROGRAMMING_PKG create/add/approve/activate
  -> TPS_PLAYOUT_API_PKG.NOW_NEXT_JSON
  -> affiliate primary failure
  -> TPS_CONTINUITY_PKG
  -> D3KA affiliate -> network
  -> NETWORK_SCHEDULE
  -> JSON playout decision
```

## Installation unit

`migrations/V0004/`

- `precheck.sql`
- `apply.sql`
- `postcheck.sql`
- `rollback.sql`
- `run.sql`
- `test.sql`
- `README.md`

## Proof sources

- compile gate: `tests/compile/COMP-003_broadcast_admin_playout.sql`
- rollback-only functional test: `tests/integration/INT-010_broadcast_end_to_end.sql`

## Current state

```text
SOURCE_BUILT=YES
MIGRATION_UNIT=YES
COMPILE_GATE_SOURCE=YES
END_TO_END_TEST_SOURCE=YES
PRODUCTION_DEPLOYED=NO_EVIDENCE
ORACLE_COMPILED=NOT_PROVEN
INT-010_EXECUTED=NO
PRODUCTION_CERTIFIED=NO
```

The only acceptable transition from `NOT_PROVEN` is actual Oracle runtime output from `migrations/V0004/run.sql` and `migrations/V0004/test.sql`.
