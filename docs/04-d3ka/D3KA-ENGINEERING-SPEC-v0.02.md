# D3KA ENGINEERING SPECIFICATION v0.02

## 1. Purpose

D3KA — Dynamic Three-Dimensional Knowledge Array — is the dominant semantic model of TPSDBCORE01. It provides a stable addressing model for knowledge while allowing unlimited contextual, temporal, semantic and governance enrichment.

## 2. Fundamental coordinate

`D3KA[X,Y,Z] = D3KA[source_entity, relation_type, target_entity]`

A coordinate is not merely an edge. A cell is a governed knowledge record.

Formal cell:

`cell = <S,R,T,C,Tv,To,P,V,E,Q,A>`

- S source entity
- R relation type
- T target entity
- C context dimensions
- Tv valid/event time
- To observation/recording time
- P extensible properties
- V zero-to-many vector representations
- E evidence/provenance set
- Q confidence/verification state
- A authorization/policy state

## 3. Tensor interpretation

D3KA is logically a sparse, dynamic tensor. Only meaningful coordinates exist. It must not be materialized as a dense cube because the entity universe and relation vocabulary are large and dynamic.

Physical realization uses normalized Oracle relational structures as authoritative state, projected into Property Graph and query/read models. Sparse relations are stored as rows, not as a dense multidimensional array.

## 4. Identity invariants

1. S and T must reference globally canonical TPS_ENTITY identities.
2. R must reference a controlled TPS_RELATION_TYPE.
3. The same real-world entity must not be duplicated solely due to role or consuming application.
4. Role semantics belong primarily to relations and context.
5. Canonical keys are immutable after certification except through controlled identity merge/split procedures.

## 5. Relation invariants

Relation types declare:
- canonical key and name;
- source entity type constraints;
- target entity type constraints;
- directed/symmetric semantics;
- cardinality expectations;
- temporal behavior;
- context requirements;
- inverse relation where applicable;
- transitivity only when semantically valid;
- provenance requirement;
- minimum confidence if relevant;
- policy classification;
- lifecycle state.

Examples: OWNS, OPERATES, AFFILIATED_WITH, REPEATS, BROADCASTS, PRESENTS, PERFORMS, PLAYED_ON, SCHEDULED_ON, TARGETS, LICENSED_BY, AUTHORIZED_FOR, PROHIBITED_IN, SIMILAR_TO, DERIVED_FROM, GENERATED_BY.

## 6. Context model

Context is not encoded into relation names. A relation may reference one or more context dimensions such as station, channel, program, region, audience, device, event, editorial class, commercial class, regulatory regime, rights window and operational condition.

Context resolution rules must define precedence and conflicts. More-specific context does not automatically override less-specific context unless the rule catalog says so.

## 7. Temporal model

D3KA supports bitemporal-style semantics where needed:
- valid_from / valid_to: when the relation is true in the business world;
- observed_at: when it was observed;
- recorded_at: when Core persisted it.

Temporal overlap constraints are relation-type dependent. Exclusive schedules, rights windows and ownership relations may require overlap detection.

## 8. Provenance and epistemic state

Every non-trivial knowledge cell may point to one or more evidence sources. Verification classes include FACT, OBSERVATION, HUMAN_ASSERTION, EXTERNAL_IMPORT, INFERENCE and AI_INFERENCE.

AI-generated or inferred relations may coexist with verified facts but must remain distinguishable and query-filterable.

## 9. Vector attachment

Vectors are not dimensions X/Y/Z. They are semantic representations attached to entities, relations, assertions or contexts through typed registries. A cell may be ranked using vector similarity without replacing graph structure.

## 10. Property Graph projection

Canonical graph:
- vertices: TPS_ENTITY;
- edges: TPS_RELATION;
- labels/properties derive from entity/relation types and safe relational columns;
- sensitive data must not be exposed as graph properties unless explicitly authorized.

Graph projections may be specialized for MUSIC, PROGRAMMING, AUDIENCE, ADVERTISING, RIGHTS, ORGANIZATION, MEDIA_ASSET and TECHNOLOGY while retaining canonical IDs.

## 11. D3KA operations

Required operations:
- assert relation;
- supersede/close relation;
- retrieve cell by coordinate;
- slice by source;
- slice by relation;
- slice by target;
- filter by context;
- filter AS OF valid time;
- filter AS KNOWN AT recorded time;
- expand neighborhood;
- compute relation paths through SQL/PGQ;
- attach/retrieve evidence;
- explain cell provenance;
- calculate semantic coverage;
- validate invariants;
- detect contradictions;
- rank candidates using graph + vector + rules.

## 12. 90% semantic coverage metric

Coverage is measured over the approved Business Knowledge Catalog.

For every business concept classify:
- ENTITY_CAPABLE
- RELATION_CAPABLE
- CONTEXT_ONLY
- EVENT_ONLY
- NUMERIC_MEASURE
- DOCUMENT/CONTENT
- EXCEPTION

For all RELATION_CAPABLE concepts, calculate weighted mapped coverage:

`coverage = sum(weight of concepts represented by canonical D3KA patterns) / sum(weight of all relation-capable concepts)`

Release target >= 0.90.

Coverage must also be reported per domain to prevent a high-volume domain from hiding an unmapped critical domain.

## 13. Query examples

Programming:
`STATION --BROADCASTS--> CHANNEL --SCHEDULED_ON<-- PROGRAM`

Music:
`ARTIST --PERFORMS--> TRACK --PLAYED_ON--> CHANNEL`

Network:
`NETWORK --OPERATES--> STATION --HAS_REPEATER--> REPEATER --SERVES--> REGION`

Advertising:
`CAMPAIGN --TARGETS--> AUDIENCE_SEGMENT --POPULAR_IN--> REGION`

Rights:
`RIGHTS_HOLDER --LICENSED--> MEDIA_ASSET --AUTHORIZED_FOR--> REGION`

## 14. Conflict classes

- identity conflict;
- mutually exclusive relations active simultaneously;
- temporal overlap violation;
- rights/policy contradiction;
- source disagreement;
- verified fact versus AI inference disagreement;
- incompatible context rules.

Conflicts are never silently resolved by AI. Resolution emits an auditable decision.

## 15. Performance principles

- index source, relation type and target patterns according to measured workload;
- include temporal indexes for AS-OF workloads;
- use graph structures for path/traversal semantics;
- use vector indexes only for measured semantic workloads;
- avoid unbounded traversals from API paths;
- set query budgets and pagination;
- maintain representative graph scale tests.

## 16. Tests

Mandatory suites:
- coordinate uniqueness/duplication policy;
- source/target type validation;
- context resolution;
- temporal overlap;
- as-of reconstruction;
- provenance filtering;
- AI inference isolation;
- graph projection parity;
- D3KA slice correctness;
- contradiction detection;
- 90% coverage calculation;
- performance baseline;
- security/visibility filtering.

## 17. Certification criteria

D3KA is CERTIFIED only when identity, relation, context, temporal, graph, provenance, vector integration, policy boundaries, coverage and performance tests all PASS with evidence on the release candidate.
