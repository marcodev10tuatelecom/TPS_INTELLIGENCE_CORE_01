# TPS_INTELLIGENCE_CORE_01

## TPS MEDIA INTELLIGENCE FABRIC CORE — Oracle AI Database 26ai

**Database:** `TPSDBCORE01`  
**OCI display name:** `TPS_INTELLIGENCE_CORE_01`  
**Environment:** **PRODUCTION**  
**Current tier:** Always Free (capacity/billing tier only)  
**Architecture:** Graph-First · D3KA/Tensor-First · AI-Native · Temporal · Multidimensional · Convergent Database  
**Canonical semantic coverage target:** `D3KA_LOGICAL_COVERAGE >= 90%`

This repository is the canonical engineering and source-code authority for the corporate database of the Tech Pro Solutions media ecosystem: radio, TV, channels, networks, affiliates, repeaters, programming, content, journalism, advertising, rights, audience, applications, automation, operations and AI.

## Canonical principle

The dominant logical representation is the **TPS Dynamic Three-Dimensional Knowledge Array (D3KA)**:

```text
D3KA(source_entity, relation, target_entity)
```

enriched by context, time, properties, provenance, confidence, vectors, policies and AI.

D3KA is a dynamic sparse logical tensor implemented over a canonical relational kernel plus Oracle Property Graph. VECTOR is complementary semantic representation, not a replacement for the tensor/graph model.

## Technology foundation

- Oracle AI Database 26ai / Autonomous AI Transaction Processing
- SQL Property Graph / SQL:2023 graph capabilities
- Oracle Property Graph / Graph Studio
- Oracle AI Vector Search / VECTOR
- JSON Relational Duality Views
- PL/SQL deterministic policy/rule engine
- Oracle Text and Spatial where justified
- Oracle Machine Learning where supported
- Select AI / DBMS_CLOUD_AI
- Select AI Agent / DBMS_CLOUD_AI_AGENT
- ORDS/API projection layer
- Unified audit, provenance and policy enforcement

## Production rule

`TPSDBCORE01` is a production database. Nothing under `src/`, `migrations/`, `security/`, `jobs/` or `ai/` is authorized for execution merely because it is committed. Every mutating deployment requires a production change record, precheck, exact scope, recovery/rollback strategy, post-check and retained evidence.

## Repository maps

Start with:

1. `PROJECT-MAP.md` — complete project/workstream map.
2. `DOCUMENTATION-MAP.md` — complete documentation map and document authority hierarchy.
3. `SOURCE-MAP.md` — complete source tree and responsibility of every source family.
4. `TRACEABILITY-MAP.md` — business → requirement → architecture → source → test → evidence.
5. `docs/04-d3ka/D3KA-FORMAL-MODEL.md` — mathematical and semantic definition of the tensor model.
6. `docs/07-ai/AI-ARCHITECTURE.md` — AI/ML/RAG/Agent architecture and authority boundaries.
7. `docs/11-testing/MASTER-TEST-STRATEGY.md` — certification strategy.
8. `docs/12-operations/PRODUCTION-CHANGE-CONTROL.md` — production deployment rules.

## Delivery gates

`CORE-00` through `CORE-20` remain the certification spine. No gate is PASS without evidence committed under `evidence/` or referenced by immutable external evidence.

## Current state

- Repository bootstrap: in progress.
- Oracle instance: production, available.
- Physical schema deployment from this repository: not yet executed.
- Production data migration: not yet executed from this repository.
- Canonical engineering: being built and versioned here.
