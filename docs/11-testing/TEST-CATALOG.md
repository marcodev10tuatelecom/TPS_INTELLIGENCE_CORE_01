# TPSDBCORE01 Test Catalog v0.01

Namespaces: UT unit, IT integration, D3KA tensor, G graph, V vector, AI artificial intelligence, SEC security, PERF performance, REC recovery, REG regression.

Core tests:
- UT-001 entity uniqueness/lifecycle constraints
- UT-002 relation temporal/confidence constraints
- D3KA-001 assert valid relation
- D3KA-002 reject forbidden self relation
- D3KA-003 require context when configured
- D3KA-004 require provenance when configured
- D3KA-005 active duplicate cell prevention
- D3KA-006 source slice
- D3KA-007 relation slice
- D3KA-008 target slice
- D3KA-009 temporal semantics
- D3KA-010 invariant view
- D3KA-011 logical coverage >= 0.90
- G-001 graph smoke query
- G-002 graph/relational equivalence
- V-001 vector constructor/distance
- V-002 exact top-K baseline
- V-003 approximate recall against exact
- AI-001 safe authority classes
- AI-002 inference verification boundary
- AI-003 policy/rights boundary
- AI-004 Graph RAG grounding/evidence
- AI-005 prompt/tool injection campaign
- SEC-001 least privilege grant inventory
- SEC-002 no DBA-like application roles
- PERF-001 entity lookup
- PERF-002 D3KA slice
- PERF-003 schedule/rights workload
- PERF-004 graph neighborhood
- PERF-005 vector latency/recall
- REC-001 schema rebuild inventory
- REC-002 migration ledger integrity
- REG-001 release regression.

Every PASS requires evidence metadata defined in docs/00-governance/EVIDENCE-STANDARD.md.
