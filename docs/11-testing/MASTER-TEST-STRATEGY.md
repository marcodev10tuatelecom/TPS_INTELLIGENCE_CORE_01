# TPSDBCORE01 — MASTER TEST, VALIDATION AND CERTIFICATION STRATEGY v0.01

## Objective

Prove correctness, safety, recoverability and performance of the production database before each capability is certified.

## Test levels

- Static review: SQL/PLSQL syntax where tooling supports, forbidden-operation scans, dependency analysis.
- Unit: constraints, packages, deterministic functions.
- Integration: cross-domain workflows and API read models.
- D3KA: cell invariants, slices, context, temporal, coverage, explainability.
- Graph: labels, edge mapping, path semantics, graph queries, graph privileges.
- Vector: dimension/type, exact distance, approximate recall, index build/update.
- AI: grounding, safety, tool authorization, policy boundary, prompt injection, provider failure.
- Security: privilege-negative, isolation, audit, secret exposure, SQL injection.
- Performance: latency percentiles, throughput, concurrency, resource use, corpus scaling.
- Recovery: export/import/rebuild, migration rollback/compensation, evidence preservation.
- Regression: full release suite.

## Mandatory evidence per test

`TEST_ID`, requirement IDs, source revision, DB version, environment identity, start/end UTC, input fixture version, expected result, actual result, PASS/FAIL, diagnostics, checksum/reference to artifacts and reviewer.

## D3KA certification suite

- creation of admissible relation;
- rejection of invalid entity/relation combinations;
- duplicate/cardinality handling;
- X/Y/Z slices;
- multi-context filter;
- valid-time and recorded-time reconstruction;
- provenance requirements;
- AI inference classification;
- policy-sensitive relation enforcement;
- graph equivalence;
- 90% logical coverage calculation;
- explain chain completeness.

## Performance methodology

No single average. Report p50/p95/p99, throughput, error rate, resource/cost indicators and dataset size. Cold/warm cache conditions are distinguished. Exact vector search is benchmark baseline for approximate-index recall.

## Production rule

Tests that mutate data or schema are never run on TPSDBCORE01 without an approved production change. Prefer isolated schema/transaction-safe fixtures where supported; otherwise use a controlled clone/migration target when paid capacity is enabled. Read-only capability tests may run under approved diagnostic change procedures.
