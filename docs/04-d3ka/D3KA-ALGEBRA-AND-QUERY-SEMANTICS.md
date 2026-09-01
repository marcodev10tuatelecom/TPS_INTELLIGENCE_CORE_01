# TPS D3KA — Algebra and Query Semantics v0.01

## 1. Coordinate system

The canonical tensor coordinate is `(s,r,t)` where `s,t ∈ E` and `r ∈ R`. A coordinate may have multiple historical/context-qualified cell versions, but only cardinality-compatible active versions may coexist.

## 2. Selection operators

Define `σ_source(s0,T)`, `σ_relation(r0,T)`, `σ_target(t0,T)`, `σ_context(c0,T)` and `σ_time(τ0,T)` as filters over qualified tensor cells. Compound slices are intersections of these predicates.

Example:

```text
σ_time(now)(σ_context(station=TVKIDS)(σ_relation(SCHEDULED_ON)(T)))
```

returns schedule relationships valid now in the TVKids station context.

## 3. Projection

`π(S,R,T,C,τ,P)(T)` returns only required dimensions/properties for downstream use. Projection never creates a second source of truth; it is a query/read model.

## 4. Composition

Relations may be composed as graph paths when semantics allow. If `(a,r1,b)` and `(b,r2,c)` are valid, a path `(a,r1,b,r2,c)` is discoverable, but no derived direct relation `(a,r3,c)` becomes canonical unless an explicit inference/policy creates an assertion with provenance.

## 5. Inverse

Relation types may define an inverse relation code. Inverse traversal is query semantics; the system need not materialize a duplicate inverse edge unless justified by workload or business semantics.

## 6. Temporal algebra

A cell is business-valid at instant `x` when `valid_from <= x < valid_to` or `valid_to` is unbounded. Knowledge-time queries may additionally filter `recorded_at`. The model therefore supports valid-time and knowledge-time reasoning without forcing full Oracle temporal features into every table.

## 7. Context algebra

Contexts can be exact, hierarchical or composite. A schedule relation qualified by station+region+program context may override a network relation only when policy declares its context more specific/authorized. Specificity is a policy function, not an assumed lexicographic rule.

## 8. Weighted/confidence semantics

`weight` is a domain score/strength. `confidence` is epistemic confidence from 0..1. They are never interchangeable. Sorting/ranking functions must declare how each is used.

## 9. Vector-assisted operations

A vector search produces candidate entities and distances/scores. D3KA then filters/expands candidates using authoritative relations, rights, context and time. A similarity result by itself is not an authoritative relation.

## 10. Explain operator

`EXPLAIN(candidate,decision)` returns the IDs of cells, assertions, sources, policies, vector model/version and AI decision records that contributed to the outcome. Human-readable prose is secondary to machine-verifiable evidence references.
