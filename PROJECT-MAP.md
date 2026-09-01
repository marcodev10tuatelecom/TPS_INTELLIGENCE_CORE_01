# TPS_INTELLIGENCE_CORE_01 — PROJECT MAP v0.01

## 1. Purpose

This file is the canonical map of the complete TPSDBCORE01 database engineering program. Every workstream must map to one or more CORE gates and must produce source, tests and evidence.

## 2. Program objective

Build and operate a production-grade Oracle AI Database 26ai corporate intelligence core for the Tech Pro Solutions media ecosystem, with a D3KA/tensor-first logical model capable of representing at least 90% of business knowledge and relationships through `source × relation × target`, enriched by context, time, provenance, confidence, vectors, policies and AI.

## 3. Program workstreams

| ID | Workstream | Primary outcomes | CORE gates |
|---|---|---|---|
| WS-00 | Governance and authority | canonical repo, ADRs, change control, evidence model | 00-20 |
| WS-01 | Business architecture | capabilities, actors, processes, rules, value streams | 00-03 |
| WS-02 | Requirements engineering | FR/NFR/data/security/AI/performance requirements | 00-20 |
| WS-03 | Oracle capability engineering | 26ai compatibility and feature matrix | 00-01 |
| WS-04 | Identity kernel | universal entity identity and types | 02-03 |
| WS-05 | D3KA relation kernel | relation types, dynamic tensor cell, invariants | 04-05 |
| WS-06 | Property Knowledge Graph | SQL Property Graph, Graph Studio, graph queries | 05,15 |
| WS-07 | Context engine | multidimensional context model and resolution | 06 |
| WS-08 | Temporal engine | valid/observed/recorded time, history, bitemporal semantics | 07 |
| WS-09 | Vector semantics | multivector, embeddings, indexes, similarity | 08 |
| WS-10 | Knowledge assertions | facts, observations, inference, provenance, confidence | 09 |
| WS-11 | AI/ML/RAG/Agents | Select AI, Graph RAG, agents, OML, model governance | 10,16 |
| WS-12 | Policy/rules | deterministic authorization and operational safety | 11 |
| WS-13 | Audit/governance | unified audit, AI decision trace, change history | 12,18 |
| WS-14 | Media domains | radio, TV, station, channel, programming, media assets | 03-14 |
| WS-15 | Commercial domains | advertising, contracts, rights, audience | 03-14 |
| WS-16 | Editorial domains | news, reports, interviews, podcasts, moderation | 03-14 |
| WS-17 | API/read models | ORDS, JSON Duality, versioned contracts | 13 |
| WS-18 | Synthetic/seed data | safe production engineering fixtures | 14 |
| WS-19 | Validation | graph, D3KA, vector, AI, integration, regression | 15-16 |
| WS-20 | Performance/capacity | SLOs, benchmarks, indexing, concurrency, cost | 17 |
| WS-21 | Security/privacy | least privilege, network/TLS, data classification | 18 |
| WS-22 | Backup/recovery/DR | export, restore, recovery drills, tier migration | 19 |
| WS-23 | Certification | evidence closure and release authority | 20 |

## 4. Canonical CORE gates

1. CORE-00 — production instance discovery and immutable baseline.
2. CORE-01 — Oracle 26ai capability and compatibility certification.
3. CORE-02 — identities, roles, schemas, privileges.
4. CORE-03 — entity kernel.
5. CORE-04 — relation kernel and D3KA cell.
6. CORE-05 — property graph.
7. CORE-06 — context engine.
8. CORE-07 — temporal engine.
9. CORE-08 — vector layer.
10. CORE-09 — assertions/provenance.
11. CORE-10 — AI/ML/RAG/agent layer.
12. CORE-11 — policy/rule engine.
13. CORE-12 — audit.
14. CORE-13 — API and JSON read models.
15. CORE-14 — synthetic/reference dataset.
16. CORE-15 — graph/D3KA validation.
17. CORE-16 — AI validation and safety.
18. CORE-17 — performance/capacity.
19. CORE-18 — security/privacy.
20. CORE-19 — backup/recovery/DR.
21. CORE-20 — certification/release.

## 5. Domain map

```text
CORPORATE
├── organizations / brands / networks
├── people / roles / identities
└── governance
MEDIA
├── radio
├── television
├── channels
├── programs
├── schedules
├── music / audio / video / images
├── live feeds
└── media assets / renditions
COMMERCIAL
├── advertisers
├── campaigns
├── contracts
├── inventory
├── placements
└── billing references
RIGHTS
├── owners
├── grants
├── territories
├── windows
└── restrictions
AUDIENCE
├── segments
├── sessions
├── observations
├── affinity
└── recommendations
EDITORIAL
├── news
├── reports
├── interviews
├── podcasts
└── provenance
OPERATIONS
├── infrastructure references
├── incidents
├── delivery events
└── service health
INTELLIGENCE
├── D3KA
├── graph
├── vector
├── assertions
├── ML
├── RAG
└── agents
```

## 6. Delivery rule

A feature is not complete because DDL exists. Completion requires: requirement → architecture → source → tests → performance/security checks where applicable → deployment evidence → rollback/recovery evidence → documentation → gate decision.
