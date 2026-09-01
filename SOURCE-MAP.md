# TPS_INTELLIGENCE_CORE_01 — SOURCE MAP v0.01

## Source authority rule

Source files implement approved design. They do not authorize execution on production. Every executable source file must identify its owning requirement(s), gate, dependencies, reversibility class and validation tests.

## Source tree

```text
src/
00-precheck/          read-only capability and state discovery
01-security/          roles, grants, contexts, audit policies
02-kernel/            entity/type/property/source foundations
03-d3ka/              relation kernel, tensor package, slicing, coverage, invariants
04-context/           context types, resolution, dimensions
05-temporal/          temporal rules, history helpers, as-of projections
06-graph/             property graph definitions and graph query views
07-vector/            vector registry, embeddings, indexes, similarity
08-knowledge/         assertion/provenance/confidence/evidence
09-event/             event types, event ledger, event correlation
10-policy/            policy/rule engine and deterministic authorization
11-ai/                AI profile metadata, RAG, agents, tools, decision ledger
12-media/             stations, channels, programs, schedules, assets, music/video
13-commercial/        advertisers, campaigns, inventory, placements
14-rights/            grants, restrictions, territories, windows
15-audience/          segments, sessions/observations, affinity
16-editorial/         news/report/interview/podcast metadata
17-api/               JSON duality, API projection views, ORDS definitions
18-observability/     health views, metrics, diagnostics
19-admin/             controlled maintenance helpers
20-reference/         reference dictionaries only
21-indexes/           relational/text/spatial/vector index definitions
22-jobs/              scheduler definitions after gate approval
23-export-import/     logical export/import metadata and validation
24-migrations/        versioned forward migrations
25-rollback/          compensating/recovery scripts where possible
26-certification/     read-only certification queries
```

## Test tree

```text
tests/
unit/                 package/function/constraint tests
integration/          cross-domain and API integration
D3KA/                 tensor cell, slice, projection, invariant, coverage tests
graph/                graph creation/query/path/label tests
vector/               distance/index/recall tests
AI/                   grounding, tool, agent, authority-boundary tests
security/             privilege-negative and audit tests
performance/          workload and latency benchmarks
recovery/             export/import and rebuild tests
regression/           release regression suites
fixtures/             synthetic/reference fixtures only
```

## Key planned source files

- `src/02-kernel/200_tps_entity_type.sql`
- `src/02-kernel/210_tps_entity.sql`
- `src/02-kernel/220_tps_property.sql`
- `src/03-d3ka/300_tps_relation_type.sql`
- `src/03-d3ka/310_tps_relation.sql`
- `src/03-d3ka/320_tps_d3ka_pkg.pks`
- `src/03-d3ka/321_tps_d3ka_pkg.pkb`
- `src/03-d3ka/330_d3ka_projection_views.sql`
- `src/03-d3ka/340_d3ka_invariants.sql`
- `src/06-graph/600_tps_media_knowledge_graph.sql`
- `src/07-vector/700_tps_vector_type.sql`
- `src/07-vector/710_tps_vector.sql`
- `src/08-knowledge/800_tps_source.sql`
- `src/08-knowledge/810_tps_assertion.sql`
- `src/10-policy/1000_tps_policy.sql`
- `src/10-policy/1010_tps_rule.sql`
- `src/10-policy/1020_tps_policy_engine_pkg.pks/.pkb`
- `src/11-ai/1100_tps_ai_agent.sql`
- `src/11-ai/1110_tps_ai_decision.sql`
- `src/11-ai/1150_graph_rag_views.sql`
- `src/12-media/*`
- `src/17-api/*`
- `src/26-certification/*`

## Reversibility classes

- R0: read-only, no persistent mutation.
- R1: additive metadata/object creation with straightforward drop before data use.
- R2: additive schema change with data/state impact; recovery script required.
- R3: destructive/transformative or externally visible change; backup/restore or blue-green strategy required.
- R4: irreversible business/event history mutation; prohibited without explicit exceptional authority.
