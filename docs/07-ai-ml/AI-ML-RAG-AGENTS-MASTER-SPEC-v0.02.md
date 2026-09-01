# AI / ML / RAG / AGENTS MASTER SPECIFICATION v0.02

## 1. Objective

Make TPSDBCORE01 AI-native without allowing probabilistic systems to silently become business, legal, editorial, rights or broadcast authority.

## 2. AI capability families

- semantic retrieval and similarity;
- entity resolution suggestions;
- metadata enrichment;
- classification and taxonomy;
- audience segmentation and affinity;
- content recommendation;
- programming assistance;
- commercial targeting assistance;
- rights/compliance analysis;
- editorial assistance;
- anomaly detection;
- natural-language analytics;
- Graph RAG;
- autonomous agents with tightly scoped tools.

## 3. Canonical agent catalog

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

Each agent requires an Agent Card with owner, mission, allowed tools, forbidden actions, inputs, outputs, data scope, policy checks, model/provider, fallback, observability, approval rules and shutdown procedure.

## 4. Authority boundary

Canonical flow:

`AI -> PROPOSAL -> POLICY -> DETERMINISTIC RULES -> RIGHTS -> SCHEDULE -> OPERATIONAL VALIDATION -> AUTHORIZED ACTION`

An AI recommendation is stored as a recommendation/decision artifact, not as executed truth. Execution state is separately recorded.

## 5. Graph RAG

Retrieval pipeline may combine:
1. identity resolution;
2. authorization filter;
3. temporal filter;
4. relational predicates;
5. property graph traversal;
6. vector similarity;
7. document/text search;
8. provenance and verification filters;
9. ranking/fusion;
10. evidence packaging;
11. model generation;
12. output validation.

Every answer affecting operational decisions must retain the evidence set used to generate it.

## 6. Vector architecture

Vectors are versioned by:
- VECTOR_TYPE;
- MODEL_ID;
- MODEL_VERSION;
- EMBEDDING_DIMENSION;
- DISTANCE_METRIC;
- SOURCE_CONTENT_VERSION;
- CREATED_AT;
- lifecycle state.

Entity multivectors may include textual, audio, image, musical-style, emotional, audience-affinity, editorial, brand, program, commercial and context embeddings.

No model upgrade overwrites historical vector lineage without traceability.

## 7. AI decision ledger

Minimum fields/concepts:
- AI_DECISION_ID;
- AGENT_ID;
- MODEL_ID/VERSION;
- REQUEST_ID/CORRELATION_ID;
- INPUT_CONTEXT;
- SOURCE_ENTITIES;
- SOURCE_RELATIONS;
- RETRIEVED_EVIDENCE;
- PROMPT/TEMPLATE VERSION or safe reference;
- TOOL_CALLS;
- OUTPUT;
- CONFIDENCE;
- POLICY_RESULT;
- FINAL_ACTION;
- HUMAN_OVERRIDE;
- CREATED_AT.

Sensitive prompts or source data must follow redaction/retention rules and need not be persisted verbatim if that would create risk.

## 8. Knowledge Steward

The Knowledge Steward may detect duplicates, propose entity merges, identify contradictory relations, missing data, stale facts, embedding gaps and taxonomy inconsistencies. It cannot autonomously merge verified identities, delete historical facts or override rights/policy.

## 9. Model/provider abstraction

Core metadata must avoid hard-coding a single external model provider into business truth. Provider/model details are versioned implementation metadata. Business contracts reference capability and quality requirements.

## 10. Model lifecycle

States:
- PROPOSED
- EVALUATING
- APPROVED
- ACTIVE
- DEGRADED
- SUSPENDED
- RETIRED

Promotion requires benchmark results, security review and regression evidence.

## 11. AI safety tests

Mandatory:
- unsupported-answer/hallucination rate;
- provenance citation correctness;
- prompt injection resistance;
- tool authorization bypass attempts;
- cross-tenant/data-scope leakage;
- rights-policy conflict handling;
- adversarial entity ambiguity;
- temporal stale-data handling;
- low-confidence abstention;
- deterministic-rule precedence;
- human-override preservation;
- model version rollback.

## 12. ML quality metrics

Metrics depend on task and may include precision/recall/F1, NDCG/MRR/Recall@K, calibration error, false-positive costs, fairness slices, drift, latency and resource cost. No universal metric is accepted for every model.

## 13. Recommendation architecture

Candidate generation may use graph traversal, vector similarity, editorial/program rules and popularity. Ranking can combine deterministic constraints and learned scores. Mandatory filters such as rights, contract state, content restrictions, frequency caps and scheduling rules run before authorization.

## 14. Explainability

For operational recommendations Core must be able to answer:
- what was recommended;
- by which agent/model/version;
- based on which entities/relations/evidence;
- which rules applied;
- which constraints excluded alternatives;
- whether a human overrode the result;
- what action actually occurred.

## 15. Privacy and security

AI tools receive only minimum required data. Secrets, credentials, private keys and unrestricted database capabilities are never model context. Sensitive personal data requires explicit classification and purpose.

## 16. Operational controls

Every agent must support:
- disable/suspend;
- model/provider change;
- tool revocation;
- rate limiting;
- timeout;
- bounded retrieval;
- audit logging;
- circuit breaker/fallback;
- manual override.

## 17. Certification

CORE-10/16 PASS requires proven feature availability on TPSDBCORE01, agent/model cards, test datasets, security tests, quality thresholds, deterministic boundary tests, performance measurements and evidence artifacts.