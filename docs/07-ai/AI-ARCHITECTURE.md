# TPSDBCORE01 — AI / ML / RAG / AGENT ARCHITECTURE v0.01

## 1. Principle

AI augments knowledge discovery and recommendation; it is not the final authority for broadcast, rights, commercial eligibility, security or destructive database operations.

```text
AI != AUTHORITY
```

## 2. AI layers

1. **Embedding layer** — text/audio/image/domain embeddings stored through TPS_VECTOR metadata.
2. **Semantic retrieval** — Oracle AI Vector Search with exact or approximate indexes chosen by measured workload.
3. **Graph retrieval** — SQL Property Graph traversal over TPS_MEDIA_KNOWLEDGE_GRAPH.
4. **Graph RAG** — vector candidates + graph expansion + temporal/context/security filters + provenance.
5. **Select AI** — natural-language query/explanation under explicitly scoped objects.
6. **ML** — predictive/affinity models where validated.
7. **Agents** — controlled tasks/tools/orchestration using DBMS_CLOUD_AI_AGENT when capability and provider configuration are certified.
8. **Decision ledger** — every material recommendation/agent action records model/profile/tool/context/policy/outcome.

## 3. Agent families

Planned logical agents:

- TPS_AI_PROGRAM_DIRECTOR
- TPS_AI_MUSIC_DIRECTOR
- TPS_AI_NEWS_DIRECTOR
- TPS_AI_COMMERCIAL_DIRECTOR
- TPS_AI_AUDIENCE_ANALYST
- TPS_AI_CONTENT_CURATOR
- TPS_AI_RIGHTS_ANALYST
- TPS_AI_COMPLIANCE
- TPS_AI_ARCHIVIST
- TPS_AI_SCHEDULER
- TPS_AI_NETWORK_OPERATOR
- TPS_AI_KNOWLEDGE_STEWARD

These names represent governed roles; deployment as actual Oracle agents requires gate CORE-10 approval.

## 4. Authority boundary

```text
REQUEST
 -> RETRIEVAL (relational + graph + vector)
 -> AI/ML PROPOSAL
 -> POLICY ENGINE
 -> RIGHTS VALIDATION
 -> SCHEDULE/COMMERCIAL/EDITORIAL RULES
 -> OPERATIONAL VALIDATION
 -> AUTHORIZED ACTION OR REJECTION
 -> AUDIT/DECISION LEDGER
```

AI may not directly call a tool that bypasses the policy engine for a protected operation.

## 5. Graph RAG retrieval contract

Graph RAG must:

1. resolve requester/security context;
2. generate/retrieve semantic candidates;
3. traverse only authorized graph labels/properties;
4. apply business-time and knowledge-time filters;
5. apply station/network/region/program context;
6. validate provenance and confidence thresholds;
7. collect citations/evidence IDs;
8. construct bounded context;
9. call approved model/provider;
10. persist decision metadata when material;
11. return answer plus evidence references and uncertainty state.

## 6. Model governance

Every model/profile requires a model card with: purpose, provider, model ID/version, data exposure classification, embedding dimension/type where applicable, evaluation dataset, accuracy/quality metrics, bias/risks, cost, latency, fallback, deprecation and owner.

## 7. Agent governance

Every agent requires an agent card with: goal, allowed tasks, allowed tools, denied tools, required policies, memory rules, maximum iterations/time/cost, model profile, human approval points, audit events, failure behavior and disable procedure.

## 8. Prompt/tool security

Untrusted content is data, never authority. Retrieved documents cannot grant privileges, expand tool scopes or alter policies. Agent tools use dedicated least-privilege credentials/roles. Prompt injection tests are mandatory.

## 9. Vector strategy

Vector types are registered, not hardcoded into entity tables. Each embedding records: target entity/assertion/content, vector type, provider/model/version, dimension, element format, normalization, created time, source hash and lifecycle state.

Index choice (exact/HNSW/IVF/hybrid) is driven by measured corpus size, latency/recall target, memory/cost and update rate. No approximate index is certified without recall evaluation against exact search.

## 10. AI validation

CORE-16 requires: grounding, hallucination rate, provenance recall, rights/policy bypass resistance, prompt injection, tool restriction, unauthorized-data leakage, temporal correctness, graph path correctness, vector recall, deterministic fallback, cost/latency and failure-mode tests.
