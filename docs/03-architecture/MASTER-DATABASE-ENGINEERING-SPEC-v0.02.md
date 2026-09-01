# MASTER DATABASE ENGINEERING SPECIFICATION v0.02

## 1. System identity

Canonical repository: `TPS_INTELLIGENCE_CORE_01`  
Production database: `TPSDBCORE01`  
Oracle service family: Autonomous AI Transaction Processing  
Database version target: Oracle AI Database 26ai  
Architecture: Graph-First, D3KA/Tensor-First, AI-Native, Temporal, Multimodel/Converged.

## 2. Mission

TPSDBCORE01 is the corporate system of record and knowledge core for Tech Pro Solutions media operations. It must support radio, television, channels, networks, affiliates, repeaters, programs, schedules, music, video, live feeds, editorial, advertising, contracts, rights, audience, people, organizations, regions, infrastructure references, applications, portals, automation and AI agents without creating isolated truths per application.

## 3. Core architectural theorem

Business reality is modeled as globally identified entities connected by typed, contextual, temporal and evidenced relations.

Canonical tensor cell:

`K = (S, R, T, C, Tv, To, P, V, Q, G)`

where:
- S = source entity;
- R = relation type;
- T = target entity;
- C = context set;
- Tv = valid/event time;
- To = observed/recorded/system time;
- P = extensible properties;
- V = vector representations;
- Q = provenance/confidence/verification quality;
- G = governance/policy/authorization state.

The user-facing term remains D3KA because the fundamental address is the three-dimensional coordinate `(source, relation, target)`. All remaining components are dynamic orthogonal dimensions attached to the cell.

## 4. Logical architecture

```text
Consumers
  -> TPS MEDIA API / controlled integrations
      -> policy/security boundary
          -> relational transaction kernel
          -> D3KA relation kernel
          -> property knowledge graph
          -> context/temporal engines
          -> vector semantic layer
          -> knowledge assertion/provenance layer
          -> rules/policy engine
          -> AI/ML/RAG/agent layer
          -> event/audit ledger
```

No browser or public application receives unrestricted database credentials.

## 5. Data authority classes

1. ORACLE_AUTHORITY — canonical business truth owned by Core.
2. APPLICATION_DERIVED — projection/cache computable from Core.
3. CLIENT_PREFERENCE — user/device preference with defined ownership.
4. CLIENT_EPHEMERAL — transient UI/session state.
5. EXTERNAL_ASSERTION — imported observation not accepted as canonical fact until policy/verification permits.
6. AI_INFERENCE — machine inference; never silently converted to fact.

## 6. Canonical kernels

### Identity
- TPS_ENTITY_TYPE
- TPS_ENTITY
- TPS_PROPERTY
- TPS_SOURCE

### D3KA
- TPS_RELATION_TYPE
- TPS_RELATION
- TPS_CONTEXT
- TPS_CONTEXT_TYPE
- TPS_RELATION_CONTEXT / equivalent normalized mapping where required
- D3KA packages, projections, coverage and invariant checks

### Knowledge
- TPS_ASSERTION
- provenance/evidence references
- confidence and verification states

### Semantic
- TPS_VECTOR_TYPE
- TPS_VECTOR
- embedding model/version metadata

### Event/audit
- TPS_EVENT_TYPE
- TPS_EVENT
- TPS_AUDIT_EVENT
- TPS_AI_DECISION

### Governance
- TPS_POLICY
- TPS_RULE
- authorization results and overrides

## 7. Domain projections

Domain tables are permitted where transactional integrity, performance, legal requirements or domain-specific constraints require them. They must still project identity and relationships into D3KA rather than create isolated universes.

Required domains:
- corporate/organization;
- station/network/channel;
- programming/schedule;
- music and media assets;
- advertising/commercial inventory;
- contracts and rights;
- audience and telemetry aggregation;
- editorial/news/podcast;
- operational references;
- API projections.

## 8. D3KA 90% rule

For each domain, maintain a coverage inventory with:
- total canonical business concepts;
- concepts with entity representation;
- relationship-bearing concepts;
- relationship concepts represented in TPS_RELATION/D3KA;
- exceptions with rationale;
- weighted semantic coverage.

Target: >= 90% weighted relationship coverage before final certification.

## 9. Temporal model

Relevant state must distinguish at minimum:
- valid_from / valid_to;
- observed_at where observation differs from occurrence;
- recorded_at/system timestamp;
- transaction/audit timestamp.

Schedules, contracts, rights, campaigns and editorial assertions require explicit temporal semantics.

## 10. AI architecture

AI is advisory unless a policy explicitly authorizes automated execution.

AI services include:
- semantic search;
- graph-aware retrieval;
- Graph RAG;
- content classification;
- entity resolution proposals;
- recommendation/ranking;
- audience analysis;
- rights/compliance assistance;
- programming assistance;
- knowledge stewardship;
- anomaly detection;
- natural-language analytics.

Every AI output that can affect business operations must be traceable to model, version, inputs, retrieved evidence, policy result, confidence and final action.

## 11. Converged Oracle technologies

Use only after CORE-01 capability proof on the actual production service:
- SQL relational constraints/transactions;
- SQL/PGQ and Property Graph;
- VECTOR / AI Vector Search;
- JSON and JSON Relational Duality Views;
- Oracle Text;
- Spatial where geospatial semantics justify it;
- PL/SQL for deterministic server-side rules;
- OML where available/appropriate;
- Select AI and AI Agent facilities where certified;
- ORDS/API facilities with least privilege.

Availability in marketing/documentation is not equivalent to capability proven on TPSDBCORE01.

## 12. Security architecture

Separate owner, migration, runtime, API, ingest, AI, analytics, auditor and administrative capabilities. Use least privilege and no shared DBA identity for applications. Secrets are never committed to Git. Production changes are audited and evidence-producing.

## 13. Performance architecture

Workload classes are isolated logically and measured independently:
- OLTP entity/relation writes;
- schedule/read-model queries;
- graph traversal;
- vector ANN/exact search;
- RAG retrieval;
- analytics;
- bulk ingest;
- audit/event append.

Every release carries baseline tests, representative datasets and regression thresholds. Indexes must be justified by measured workload.

## 14. Availability and recovery

The current tier does not waive production recovery requirements. Where native service capabilities are insufficient, compensate with logical export, source-controlled schema, reference/seed reconstruction, external evidence and a tested migration/rebuild procedure. A backup claim is accepted only after restoration/rebuild has been demonstrated to the required RPO/RTO class.

## 15. Engineering lifecycle

`Business -> Requirements -> Architecture -> Data/D3KA Model -> Physical Design -> Source -> Static Validation -> Non-production-compatible verification where possible -> Controlled Production Change -> Post-check -> Evidence -> Certification`.

## 16. Release states

- DRAFT
- REVIEWED
- APPROVED_DESIGN
- SOURCE_READY
- TESTED
- PRODUCTION_CHANGE_APPROVED
- DEPLOYED
- CERTIFIED
- SUPERSEDED
- RETIRED

## 17. Prohibited shortcuts

- application-specific duplicate systems of record;
- AI inference stored as verified fact without provenance/state;
- unversioned schema changes;
- direct ad-hoc production DDL without change package;
- undocumented grants;
- secrets in repository;
- destructive migration without recovery strategy;
- declaring PASS without evidence;
- claiming 90% D3KA coverage without measured catalog.
