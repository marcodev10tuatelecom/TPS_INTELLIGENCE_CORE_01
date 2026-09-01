# TPS_INTELLIGENCE_CORE_01 — DOCUMENTATION-FIRST POLICY v0.02

## 1. Authority

This policy is mandatory for every database artifact in `TPS_INTELLIGENCE_CORE_01`.

The project adopts the rule:

> Documentation is equal to or more important than executable database code because the code cannot be safely operated, audited, evolved, recovered, migrated or certified without an exact description of intent, dependencies, impact and evidence.

`TPSDBCORE01` is a PRODUCTION Oracle AI Database 26ai database. Source code stored in GitHub is not automatically deployed. Every mutating production action remains subject to production change control.

## 2. Definition of a documented source

A source file is not `SOURCE_READY` unless the source itself contains an embedded documentation contract covering, at minimum:

1. file identity and canonical path;
2. project/database/environment;
3. owning CORE gate and workstream;
4. source state and production deployment state;
5. reversibility class;
6. purpose and business reason;
7. objects created, replaced, queried or modified;
8. routine-by-routine documentation when procedures/functions/packages exist;
9. inputs, outputs and side effects;
10. upstream dependencies;
11. downstream consumers;
12. D3KA role and semantic links;
13. AI/ML/RAG/Agent role, or explicit `NONE`;
14. security/privacy implications;
15. performance/capacity/locking implications;
16. transaction and concurrency behavior;
17. idempotency/re-execution behavior;
18. failure modes and expected Oracle errors where material;
19. rollback/recovery approach;
20. exact test references;
21. evidence/certification references;
22. external technology references;
23. internal documentation links;
24. change history.

## 3. Routine-level rule

Every declared or implemented PL/SQL `FUNCTION` or `PROCEDURE` must have an adjacent `@routine` documentation block.

The routine block must state:

- name;
- purpose;
- inputs and validation rules;
- return/output semantics;
- read/write side effects;
- tables/views/packages read;
- tables/packages written/called;
- D3KA impact;
- AI authority impact;
- security/privilege assumptions;
- transaction/locking behavior;
- performance complexity or dominant access path;
- explicit failure conditions;
- caller/callee links;
- unit/integration tests.

## 4. Referential documentation

Every source must link both directions:

```text
REQUIREMENT
  -> DESIGN / ADR
      -> SOURCE FILE
          -> DATABASE OBJECT
              -> ROUTINE
                  -> TEST
                      -> EVIDENCE
                          -> CORE GATE
```

Where the source participates in D3KA, its link must also identify one or more of:

```text
ENTITY
RELATION
CONTEXT
TEMPORAL
PROVENANCE
VECTOR
POLICY
AI
GRAPH
```

## 5. Production impact classification

Each source must declare one of:

- `READ_ONLY` — no persistent change;
- `R1_ADDITIVE` — additive object, straightforward pre-use removal;
- `R2_STATEFUL` — schema/state change requiring recovery plan;
- `R3_TRANSFORMATIVE` — destructive, externally visible, or data-transforming; backup/restore or blue-green required;
- `R4_IRREVERSIBLE_HISTORY` — forbidden without exceptional explicit authority.

## 6. No undocumented deployment

A production change must be rejected when any of the following is true:

- source documentation contract missing;
- routine block missing;
- dependency unresolved;
- rollback/recovery undefined;
- tests undefined or failing;
- evidence target undefined;
- version/technology reference not verified for the installed Oracle release;
- security/performance impact marked `UNKNOWN` without an approved exception.

## 7. Documentation quality gate

The repository must keep an automated documentation validator. Pull requests that add or modify executable source must fail the documentation gate when required metadata is absent.

Documentation correctness is reviewed as an engineering deliverable, not as optional comments.

## 8. Canonical references

- `PROJECT-MAP.md`
- `DOCUMENTATION-MAP.md`
- `SOURCE-MAP.md`
- `TRACEABILITY-MAP.md`
- `docs/00-governance/DEFINITION-OF-COMPLETE.md`
- `docs/06-data-dictionary/SOURCE-FILE-DOCUMENTATION-STANDARD.md`
- `docs/06-data-dictionary/SOURCE-EMBEDDED-DOCUMENTATION-CONTRACT-v0.02.md`
- `SOURCE-FILE-CATALOG-v0.02.md`

## 9. Change rule

A code change that modifies behavior without updating its embedded documentation is an incomplete change and cannot be certified.
