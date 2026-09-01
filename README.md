# TPS_INTELLIGENCE_CORE_01

## Production Oracle AI Database 26ai engineering repository

**Database:** `TPSDBCORE01` / `TPS_INTELLIGENCE_CORE_01`  
**Environment:** **PRODUCTION**  
**Current tier:** Always Free — capacity/billing property only  
**Architecture:** D3KA/Tensor-First · Graph-First · AI-Native · Temporal · Multidimensional · Convergent  
**D3KA semantic coverage target:** `>= 90%`

## START HERE — canonical recovery chain

If chat/session context is lost, do **not** reconstruct the project from memory. Read these files in order:

1. `CANONICAL-PROJECT-MANUAL-v0.03.md` — current master/recovery manual.
2. `docs/00-governance/NAMING-AND-IDENTITY-REGISTER-v0.03.md` — every important name, origin and approval state.
3. `docs/15-evidence/ENGINEERING-STATE-LEDGER-v0.03.md` — what exists in source versus what is actually proven in production.
4. `PROJECT-MAP.md` — workstreams and CORE gates.
5. `TRACEABILITY-MAP.md` — requirement -> source -> test -> evidence chain.
6. `docs/06-data-dictionary/SOURCE-ROUTINE-DEPENDENCY-CATALOG-v0.03.md` — source files, objects, routines, dependencies and consumers.
7. `docs/03-architecture/MASTER-DATABASE-ENGINEERING-SPEC-v0.02.md` — master database architecture.
8. `docs/04-d3ka/D3KA-ENGINEERING-SPEC-v0.02.md` — D3KA/tensor engineering.
9. `docs/03-architecture/PLSQL-CALL-GRAPH-v0.03.md` — implemented PL/SQL call paths.
10. `docs/00-governance/PROJECT-RECOVERY-RUNBOOK-v0.03.md` — exact context-loss recovery procedure.

## Canonical principle

The dominant logical knowledge model is the **TPS Dynamic Three-Dimensional Knowledge Array (D3KA)**:

```text
D3KA(source_entity, relation, target_entity)
```

enriched by context, time, properties, provenance, confidence, vectors, policies and AI.

It is a dynamic sparse logical tensor implemented over a canonical relational kernel plus Oracle Property Graph. VECTOR is complementary semantic geometry, not a replacement for D3KA.

## Authority invariant

```text
ONE_RELATIONAL_AUTHORITY=YES
AI_RECOMMENDATION != AUTHORIZED_OPERATION
SOURCE_STATE != PRODUCTION_STATE
```

Being present in Git never proves an object is deployed, compiled VALID, functionally tested or certified in TPSDBCORE01.

## Naming rule

Names explicitly supplied/approved by the project owner are recorded as `USER_CANONICAL` or `APPROVED_CANONICAL`.

Technical names introduced during engineering are `ENGINEERING_PROVISIONAL` until owner approval. No engineer/assistant may silently represent an engineering-provisional name as an owner decision.

See `docs/00-governance/NAMING-AND-IDENTITY-REGISTER-v0.03.md` and ADR-0004.

## Current source architecture

Repository source currently covers:

- database/capability prechecks;
- universal entity identity;
- D3KA relation/tensor kernel;
- context and temporal engines;
- Oracle Property Graph source;
- VECTOR semantics;
- assertions/provenance;
- event fabric;
- rights and policy;
- AI model/agent/tool/decision structures;
- bounded AI capability guard;
- programming and schedule engine;
- 24x7 continuity/fallback using D3KA affiliate/network links;
- programming hard-rule engine;
- commercial placement authorization;
- audience/editorial/API/observability/admin/reference/certification source families.

## Migration units

- `V0001` — Canonical Kernel Bootstrap — source/design exists; README states NOT EXECUTED.
- `V0002` — Programming + AI Capability Guard + 24x7 Continuity — source exists; runtime compile/functional PASS not proven.
- `V0003` — Programming Rules + Commercial Authorization — source exists; runtime compile/functional PASS not proven.

Every migration has/shall have precheck, exact apply order, postcheck, test linkage and rollback/recovery documentation.

## Technology foundation

Subject to runtime compatibility proof on the actual production service:

- Oracle AI Database 26ai / Autonomous AI Transaction Processing;
- relational SQL constraints and transactions;
- PL/SQL deterministic packages;
- SQL Property Graph / SQL-PGQ;
- Oracle AI Vector Search / VECTOR;
- JSON and JSON Relational Duality;
- Select AI / `DBMS_CLOUD_AI`;
- AI Agent / `DBMS_CLOUD_AI_AGENT`;
- Oracle Text/Spatial/OML where justified and proven;
- ORDS/API projection layer;
- audit, provenance, policy and recovery controls.

## Production rule

`TPSDBCORE01` is production. Nothing under `src/`, `migrations/`, `tests/`, AI templates or reference data is authorized for production execution merely because it is committed.

A production mutation requires explicit change authority, precheck, exact scope, recovery plan, postcheck, evidence and gate decision.

## Definition of complete

A capability is not complete because a table/package exists. Completion requires business purpose, requirement, naming approval, architecture, D3KA/data semantics, source, embedded routine documentation, tests, security, performance, operations, recovery, deployment evidence and certification.

See `docs/00-governance/DEFINITION-OF-COMPLETE.md`.
