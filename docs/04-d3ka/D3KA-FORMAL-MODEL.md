# TPS D3KA — FORMAL TENSOR / KNOWLEDGE MODEL v0.01

## 1. Definition

TPS D3KA (Dynamic Three-Dimensional Knowledge Array) is the dominant logical representation of business knowledge in TPSDBCORE01.

Let `E` be the set of canonical entities and `R` the set of canonical relation types. The sparse tensor domain is:

```text
T = E × R × E
```

A populated tensor cell is not merely Boolean. A cell is an ordered knowledge record:

```text
C = (s, r, t, c, τ, p, π, q, v, ω, a)
```

where:
- `s` = source entity;
- `r` = relation type;
- `t` = target entity;
- `c` = context reference or context set;
- `τ` = temporal state (valid/observed/recorded intervals);
- `p` = extensible properties;
- `π` = provenance/evidence references;
- `q` = confidence/quality state;
- `v` = zero or more vector-space references;
- `ω` = policy/rule applicability;
- `a` = AI annotations/decisions, never automatic authority.

Canonical shorthand:

```text
D3KA(source_entity, relation, target_entity)
```

## 2. Sparse representation

The tensor is sparse: only meaningful relations are materialized. It is not stored as a dense cubic array. Physical persistence uses normalized Oracle tables for entity/relation/context/provenance plus SQL Property Graph projection. This avoids O(|E|²|R|) dense storage.

## 3. Dynamic dimensions

The three primary axes are stable semantically, while values are dynamic:

- X/source: any canonical entity.
- Y/relation: controlled extensible relation taxonomy.
- Z/target: any canonical entity.

Context and time are not forced into extra physical array dimensions; they qualify cells and allow multidimensional slicing without exploding schema cardinality.

## 4. Tensor operations

Required operations:

- `PUT/ASSERT`: establish a qualified relation subject to authority and invariants.
- `RETRACT/END_VALIDITY`: end relation validity without erasing history.
- `SLICE_X(s)`: all outgoing relations for source.
- `SLICE_Y(r)`: all cells for relation type.
- `SLICE_Z(t)`: all incoming relations for target.
- `SLICE_CONTEXT(c)`: relations applicable to context.
- `SLICE_TIME(t)`: relations valid/observed at time.
- `PROJECT(S,R,T)`: restricted tensor projection.
- `PATH`: graph traversal through qualified cells.
- `NEIGHBORHOOD`: k-hop graph neighborhood.
- `AGGREGATE`: relation/context/time aggregation.
- `EXPLAIN`: return provenance, confidence, rules and AI contribution.
- `COVERAGE`: measure domain facts represented by D3KA.

## 5. Invariants

Mandatory invariants include:

1. Source and target entities exist and are not soft-deleted beyond allowed historical references.
2. Relation type exists and declares admissible source/target categories when constrained.
3. Temporal interval is coherent (`valid_to > valid_from` when bounded).
4. No silent overwrite of historically relevant cells.
5. Confidence is bounded and its scale/version is known.
6. AI-generated/inferred cells are distinguishable from facts/observations.
7. Rights/policy-sensitive relations cannot bypass deterministic validation.
8. Provenance is mandatory for imported, observed, inferred and AI-generated assertions.
9. Duplicate active cells are prevented according to relation cardinality policy.
10. Tenant/network/station security context must be enforceable for protected data.

## 6. 90% coverage target

`D3KA_LOGICAL_COVERAGE >= 0.90` means at least 90% of modeled business facts/relationships selected for canonical coverage can be represented as canonical entities plus qualified D3KA relations. It does NOT mean 90% of physical bytes or tables are graph edges.

Coverage is measured by a registry of domain fact classes:

```text
coverage = represented_fact_classes / eligible_fact_classes
```

weighted coverage may also be reported, but unweighted coverage remains visible to prevent gaming.

## 7. Graph equivalence

Each active D3KA cell maps naturally to a property-graph edge:

```text
(source vertex)-[relation edge]->(target vertex)
```

The relational tables are the system of record. The Oracle SQL Property Graph is a graph projection over that system of record, preserving one authority.

## 8. Vector complement

Vectors model semantics/similarity. They do not encode authoritative relationships. A relation may reference vector-derived evidence or scores, but converting similarity into an operational relation requires policy and provenance.

## 9. Temporal semantics

Every relation may carry:

- `valid_from`, `valid_to`: business validity;
- `observed_at`: when observed externally;
- `recorded_at`: when persisted;
- optional revision/supersession references.

This supports as-of reconstruction and separates event time from knowledge time.

## 10. Explainability

Every decision-oriented tensor slice must be explainable through the chain:

```text
candidate entities
-> qualifying relations
-> context filters
-> temporal filters
-> rights/policy filters
-> vector/ML scores
-> deterministic ranking/constraints
-> AI recommendation (if any)
-> authorized result
```

The explain result must identify source relations and evidence IDs, not only a natural-language narrative.
