# AI Requirements

- AIR-001 AI output is proposal unless deterministic policy grants bounded authority.
- AIR-002 every material recommendation records model/profile/version and context.
- AIR-003 Graph RAG returns evidence IDs/provenance, not unsupported narrative only.
- AIR-004 embeddings are versioned and reproducible from source/hash where feasible.
- AIR-005 approximate vector indexes are evaluated against exact-search recall.
- AIR-006 prompt injection/untrusted-content tests are mandatory.
- AIR-007 agent tools use explicit allowlists and least privilege.
- AIR-008 agent memory is classified, bounded and auditable.
- AIR-009 provider/model failures have deterministic fallback or explicit unavailable state.
- AIR-010 unauthorized graph/data must not enter prompts or tool results.
- AIR-011 hallucinated facts cannot be silently persisted as verified facts.
- AIR-012 model/agent deprecation has lifecycle and rollback/disable procedure.
