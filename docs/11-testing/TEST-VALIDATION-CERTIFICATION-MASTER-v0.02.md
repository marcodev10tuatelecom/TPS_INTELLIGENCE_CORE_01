# TEST, VALIDATION & CERTIFICATION MASTER v0.02

## 1. Test doctrine

Every requirement is either tested, inspected with evidence, or explicitly marked NOT TESTABLE with approved rationale. No mandatory item may be silently omitted.

## 2. Test layers

T0 static/source review  
T1 object compile/syntax validation  
T2 unit tests  
T3 relational integrity/constraint tests  
T4 D3KA invariant tests  
T5 temporal/context tests  
T6 graph/SQL-PGQ tests  
T7 vector/semantic tests  
T8 cross-domain integration  
T9 API/read-model tests  
T10 AI/RAG/agent quality and safety  
T11 security negative tests  
T12 performance/concurrency/stress  
T13 backup/rebuild/recovery  
T14 migration/rollback  
T15 production post-deployment certification

## 3. Test data

Use controlled synthetic/reference fixtures by default. Each fixture set has a version and expected invariants. Production business records are not copied into tests merely for convenience.

## 4. D3KA mandatory cases

- canonical identity uniqueness;
- permitted and forbidden source/target type combinations;
- duplicate active-cell rules;
- symmetric/inverse relation behavior where defined;
- context precedence;
- valid-time boundaries;
- temporal overlap conflicts;
- current/as-of/as-known-at reconstruction;
- provenance filtering;
- fact vs AI inference isolation;
- graph projection parity;
- vector attachment lineage;
- conflict detection;
- coverage >= 90% at certification scope.

## 5. AI mandatory cases

- grounding/evidence correctness;
- unsupported-answer abstention;
- hallucination measurement;
- injection/tool-abuse resistance;
- authorization boundary;
- model/version traceability;
- deterministic-policy precedence;
- rights and schedule blocking;
- human override;
- degraded model/provider behavior;
- agent disable/revoke flow.

## 6. Security mandatory cases

Privilege-negative tests are required for every service role. Tests must attempt prohibited DDL/DML, sensitive-view access, graph traversal, vector retrieval, AI tool calls and administration.

## 7. Performance test protocol

A benchmark definition includes dataset profile, query/workload, concurrency, warm/cold condition, repetitions, success criteria, resource metrics and regression threshold. Single manual timings are not certification evidence.

## 8. Migration testing

Every production migration must be tested for:
- precondition mismatch;
- idempotence policy;
- compile failures;
- partial failure;
- dependency ordering;
- rollback/compensating path;
- data reconciliation;
- post-deployment regression.

## 9. Evidence format

Every test run emits at minimum:
- TEST_RUN_ID;
- UTC timestamp;
- release/commit SHA;
- database/service identifier without secrets;
- test suite version;
- dataset version;
- PASS/FAIL/SKIP counts;
- failures with stable test IDs;
- checksum of evidence bundle.

## 10. Certification matrix

CORE-03 Entity: identity + constraints + negative tests  
CORE-04 D3KA relation: relation semantics + invariants  
CORE-05 Graph: creation/query/parity/security  
CORE-06 Context: resolution/conflict  
CORE-07 Temporal: as-of/overlap/history  
CORE-08 Vector: correctness/recall/performance/lineage  
CORE-09 Knowledge: provenance/verification/conflict  
CORE-10 AI: feature + architecture  
CORE-11 Policy: deterministic authorization  
CORE-12 Audit: trace completeness  
CORE-13 API: contract/auth/performance  
CORE-14 Dataset: fixture integrity  
CORE-15 Graph/D3KA: full coverage/integration  
CORE-16 AI: safety/quality  
CORE-17 Performance: SLO/capacity  
CORE-18 Security: privilege/attack tests  
CORE-19 Recovery: rebuild/restore/migration proof  
CORE-20 Release: all required evidence closed.

## 11. Release rule

A failed mandatory test blocks certification. A skipped mandatory test is a failure unless explicitly waived by documented authority with residual risk.
