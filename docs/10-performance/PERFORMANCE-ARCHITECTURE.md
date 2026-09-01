# Performance Architecture

Workload classes: OLTP identity/relation writes, schedule/rights lookups, graph traversals, vector search, Graph RAG retrieval, analytics, bulk ingest, API read models and audit/event append.

Measure p50/p95/p99 latency, throughput, errors, concurrency, resource consumption and dataset size. Graph/vector/AI paths have independent SLOs because their cost profiles differ.

Optimization order: correct model/query -> relational indexes/partitioning where justified -> graph query design -> vector index strategy -> caching/read models -> capacity tier. Do not optimize by duplicating canonical truth without explicit architecture.
