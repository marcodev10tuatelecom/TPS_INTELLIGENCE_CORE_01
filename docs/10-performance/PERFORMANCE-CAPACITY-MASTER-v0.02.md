# PERFORMANCE & CAPACITY ENGINEERING MASTER v0.02

## 1. Principle

Performance is certified by measurement on representative workloads, not by assumptions. Oracle object/index choices are justified by workload evidence.

## 2. Workload classes

P1 OLTP identity/relation writes  
P2 station/channel/program reads  
P3 schedule resolution/current programming  
P4 D3KA coordinate lookup/slices  
P5 property graph traversal  
P6 vector similarity/ANN  
P7 Graph RAG retrieval fusion  
P8 event/audit append  
P9 bulk/reference ingest  
P10 analytics/aggregation  
P11 API JSON/Duality read models  
P12 AI decision ledger

Each class has independent latency, throughput, concurrency, resource and failure thresholds.

## 3. Dataset scale profiles

S0 developer/synthetic minimum  
S1 certification small  
S2 expected initial production  
S3 10x expected production  
S4 stress/breakpoint

Scale profiles must define entity count, relation count, average degree, graph depth, vector count/dimension, event volume, schedules, assets, campaigns, rights windows and audience aggregates.

## 4. D3KA performance

Benchmark:
- exact coordinate `(S,R,T)`;
- source slice;
- relation slice;
- target slice;
- context-constrained slice;
- valid-time/as-known-at filters;
- 1/2/3/N-hop graph traversal;
- high-degree vertices;
- contradiction/coverage views;
- graph+vector candidate ranking.

Unbounded traversal is prohibited from online API execution paths.

## 5. Vector performance

Measure exact and indexed search separately. Record Recall@K when approximate indexing is used. Test dimension, vector count, filter selectivity, K, distance metric, concurrency, index build time and index storage.

## 6. AI/RAG performance

Break down latency into authorization, identity resolution, relational filters, graph traversal, vector search, evidence assembly, model call, tool execution and policy validation. Model latency must not hide slow database retrieval.

## 7. Index engineering

An index is accepted when it improves an identified workload enough to justify DML/storage/build cost. Duplicate/unused indexes are rejected. Separate index source files by purpose and keep benchmark before/after evidence.

## 8. Concurrency

Test read/write contention around relation supersession, schedule updates, rights/campaign changes, event append and AI decision logging. Detect lock amplification and long transactions.

## 9. Tier awareness

Always Free resource limits are current production constraints. Performance thresholds are recorded for the current tier and separately for target paid capacity when promoted/migrated. The logical architecture must not depend on free-tier limits.

## 10. Baseline report

Every certified release records:
- database/service configuration relevant to performance;
- dataset profile;
- query IDs and SQL text hash/reference;
- execution statistics/plans where available;
- p50/p95/p99 latency;
- throughput;
- concurrency;
- CPU/session/storage indicators;
- errors/timeouts;
- regression versus prior release.

## 11. Fail criteria

Fail when mandatory workload exceeds release SLO, causes unsafe resource exhaustion, produces unbounded plans, degrades critical OLTP beyond threshold or cannot meet recovery/operational requirements.

## 12. CORE-17

CORE-17 passes only after representative datasets, all critical workload classes, index justification, concurrency, scale and regression tests are evidenced.