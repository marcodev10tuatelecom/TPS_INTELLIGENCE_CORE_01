# V0001 — Canonical Kernel Bootstrap

## Repository state

```text
SOURCE=BUILT
PRECHECK=BUILT_FAIL_CLOSED
APPLY=BUILT
POSTCHECK=BUILT_FAIL_CLOSED
COMPILE_GATE=COMP-000
RUNNER=run.sql
PRE_DATA_ROLLBACK=rollback.sql
PRODUCTION_RUNTIME=NOT_PROVEN
```

## Scope

V0001 creates the canonical TPSDBCORE01 foundation required by later migrations:

- migration ledger;
- entity/source/context kernel;
- D3KA relation/tensor kernel;
- reference taxonomies;
- vector/knowledge/event/policy/AI/audit structures;
- station/channel/program/schedule/media projections;
- commercial, rights, audience and editorial base tables;
- rights/policy PL/SQL packages;
- Oracle Property Graph projection and initial API views.

## Safety model

`precheck.sql` is read-only and fails if representative canonical core objects already exist. A partially populated/existing TPS schema must be reconciled instead of blindly bootstrapped.

`apply.sql` is a production mutation and is not authorized merely by repository presence.

`postcheck.sql` invokes `tests/compile/COMP-000_kernel.sql` and fails on missing/invalid mandatory objects or `USER_ERRORS`.

`rollback.sql` is authorized only immediately in a pre-business-data/pre-V0002 state. After canonical data exists, use forward correction or approved restore/rebuild instead of destructive rollback.

## Execution

```text
@run.sql
```

Expected terminal marker:

```text
V0001_RUN=PASS
```

Runtime status remains `NOT_PROVEN` until actual TPSDBCORE01 output is retained as evidence.
