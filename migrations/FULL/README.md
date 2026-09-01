# TPSDBCORE01 — FULL BUILD CHAIN

## Purpose

Provide one deterministic source-controlled path from an empty compatible schema to the current functional broadcast core.

## Sequence

```text
V0001  Canonical kernel bootstrap
  -> V0002 Programming + AI capability guard + 24x7 continuity
      -> V0003 Programming rules + commercial authorization
          -> V0004 Broadcast administration + rights administration + playout API
```

## Empty-target build

`run_from_empty.sql` is allowed only when V0001 precheck proves that the canonical TPS core is absent. It stops on the first error.

## Validation

`test_all.sql` executes compile gates and rollback-only synthetic functional tests after all migrations are installed.

Expected terminal markers:

```text
V0001_RUN=PASS
V0002_RUN=PASS
V0003_RUN=PASS
V0004_RUN=PASS
TPS_FULL_BUILD=PASS

V0002_TEST=PASS
V0003_TEST=PASS
V0004_TEST=PASS
TPS_FULL_TEST=PASS
```

## Production warning

Repository source is not deployment authority. TPSDBCORE01 is production. Before any execution, the actual runtime state must be discovered and reconciled. Do not run `run_from_empty.sql` against a schema containing any canonical TPS objects.
