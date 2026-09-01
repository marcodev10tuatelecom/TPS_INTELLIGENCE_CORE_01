# TPS_INTELLIGENCE_CORE_01 — TRACEABILITY MAP v0.03

## 1. Traceability chain

```text
BUSINESS NEED
  -> BUSINESS REQUIREMENT (BR)
  -> SYSTEM REQUIREMENT (SR)
  -> DATA/AI REQUIREMENT (DR/AIR)
  -> ARCHITECTURE DECISION (ADR)
  -> SOURCE OBJECT/FILE
  -> ROUTINE/TRIGGER/VIEW
  -> TEST CASE
  -> EVIDENCE
  -> CORE GATE
  -> RELEASE/CERTIFICATION
```

Requirement IDs are never silently recycled. A requirement may be refined but its history remains visible.

## 2. Canonical business/system requirements and implementation links

| ID | Requirement | Current design/source | Primary tests/evidence | Gate/state |
|---|---|---|---|---|
| BR-001 | One corporate source of truth for media identities | `TPS_ENTITY_TYPE`, `TPS_ENTITY` | unit/kernel + D3KA | CORE-03 source exists |
| BR-002 | Radio/TV/network/affiliate/repeater relationships without duplicate identities | `TPS_RELATION_TYPE`, `TPS_RELATION`, D3KA | D3KA/graph | CORE-04/05 source exists |
| BR-003 | Regional/local programming while sharing network content | schedules + D3KA `REPEATS`/`AFFILIATED_WITH` | PRG-900 + future quota tests | CORE-06/14 partial source |
| BR-004 | 24x7 programming authority independent of local studio presence | `TPS_CONTINUITY_PKG`, continuity ledger | COMP-001, PRG-900 | source built; runtime not proven |
| BR-005 | Rights-aware content decisions | `TPS_RIGHT_GRANT`, `TPS_RIGHTS_PKG` | rights/policy/programming tests | source built; territory/context incomplete |
| BR-006 | Advertising eligibility/frequency enforcement | `TPS_CAMPAIGN`, `TPS_PLACEMENT`, `TPS_COMMERCIAL_PKG` | COMP-002, PRG-910, commercial tests | source built; runtime not proven |
| BR-007 | Auditable AI recommendations/actions | `TPS_AI_DECISION`, `TPS_AI_AGENT_TOOL`, guard/tool packages | AI tests, PRG-900 | source built; runtime not proven |
| BR-008 | Historical reconstruction of business state | temporal relation/context/event state | temporal/D3KA regression | source built |
| BR-009 | Semantic similarity and recommendation | `TPS_VECTOR_TYPE`, `TPS_VECTOR`, exact query/ANN templates | vector/performance | runtime capability not proven |
| BR-010 | Applications consume controlled contracts, not DBA access | API/Duality views + package boundaries | API/security future | partial source |
| BR-011 | Invalid schedule overlap must be rejected | `TPS_PROGRAMMING_PKG.ADD_SCHEDULE_ITEM` | PRG-900 overlap negative path | source built |
| BR-012 | Scheduled file content must have active media asset | programming package | PRG-900 + future asset tests | source built |
| BR-013 | Unknown/denied rights must fail closed | rights/programming/commercial packages | PRG-900/PRG-910 | source built |
| BR-014 | Schedule approval must obey broadcaster hard rules | `TPS_PROGRAMMING_RULE_PROFILE`, rules package, schedule guard trigger | COMP-002, PRG-910 | source built |
| BR-015 | Content repeat window must be enforceable per broadcaster owner | `REPEAT_VIOLATION_COUNT` | PRG-910 | source built |
| BR-016 | Commercial load per rolling hour must be bounded | `COMMERCIAL_SECONDS_ROLLING_HOUR` | PRG-910 | source built |
| BR-017 | Content classification must constrain schedule approval | `TPS_CONTENT_RATING` + programming rules | PRG-910 | source built; legal reference review pending |
| BR-018 | Media duration mismatch must be detectable before approval | media asset duration + rule profile tolerance | PRG-910 | source built |
| BR-019 | Commercial schedule items require authorized placement where policy requires | programming rules + placement | PRG-910 | source built |
| BR-020 | Commercial placement must check campaign, asset, rights and frequency | `TPS_COMMERCIAL_PKG` | commercial/PRG-910 | source built |
| BR-021 | Continuity decisions must be immutable evidence | `TPS_CONTINUITY_DECISION` + immutable trigger | PRG-900 mutation-negative test | source built |
| BR-022 | AI must not receive arbitrary SQL authority to program schedules | AI guard + bounded programming tool -> programming package | AI negative tests + PRG-900 | source built |
| BR-023 | AI bounded execution must be locally atomic | SAVEPOINT/ROLLBACK TO SAVEPOINT in AI programming tool | PRG-900 failure/success paths | source built |

## 3. System requirements

| ID | Requirement | Design/source | Test family | Gate |
|---|---|---|---|---|
| SR-001 | >=90% logical knowledge coverage through D3KA | fact-class/mapping/coverage model | D3KA-011 + future weighted/domain suite | CORE-15 |
| SR-002 | AI cannot directly authorize protected broadcast/commercial/right-sensitive action | deterministic package boundaries | AI negative + programming/commercial | CORE-10/11/16 |
| SR-003 | Important assertions carry provenance/confidence | `TPS_SOURCE`, `TPS_ASSERTION`, relation provenance | knowledge/AI | CORE-09 |
| SR-004 | Every production mutation has change/audit evidence | migrations, audit/change control | audit/change evidence | CORE-12/20 |
| SR-005 | Performance measured by workload class | performance architecture and benchmarks | PERF-* | CORE-17 |
| SR-006 | Recovery certified by actual rebuild/restore drill | recovery architecture/migrations | REC-* | CORE-19 |
| SR-007 | Source state is independent from deployed runtime state | state ledger/migration evidence | object/status/compile evidence | all gates |
| SR-008 | PL/SQL package compilation requires zero relevant USER_ERRORS | COMP-001/COMP-002 | compile evidence | CORE-14/20 |
| SR-009 | Schedule item overlap check must be concurrency-safe | `SELECT ... FOR UPDATE` schedule edit serialization | concurrency test pending | CORE-17/18 |
| SR-010 | AI bounded operation must not commit caller transaction | no COMMIT + local savepoint | transaction tests | CORE-16/18 |
| SR-011 | Evidence ledgers protected from casual history rewrite | immutability trigger/audit | negative tests | CORE-12/18 |
| SR-012 | Names introduced by engineering are not silently owner-canonical | naming register/ADR-0004 | documentation review | WS-00/all gates |
| SR-013 | Project must be recoverable without chat history | canonical manual + recovery runbook | documentation recovery review | WS-00/all gates |

## 4. Key source-to-test links

```text
TPS_D3KA_PKG
 -> tests/D3KA/*

TPS_TEMPORAL_PKG
 -> tests/temporal/test_temporal_pkg.sql

TPS_MEDIA_KNOWLEDGE_GRAPH
 -> tests/graph/*

TPS_VECTOR
 -> tests/vector/* + tests/performance/PERF-005_vector_exact.sql

TPS_RIGHTS_PKG
 -> programming/policy/right-specific tests

TPS_PROGRAMMING_PKG
 -> tests/compile/COMP-001_programming_continuity.sql
 -> tests/programming/PRG-900_vertical_plsql_slice.sql

TPS_CONTINUITY_PKG
 -> COMP-001
 -> PRG-900

TPS_AI_GUARD_PKG
TPS_AI_PROGRAMMING_TOOL_PKG
 -> AI negative tests
 -> PRG-900

TPS_PROGRAMMING_RULES_PKG
TRG_TPS_SCHEDULE_POLICY_GUARD
TPS_COMMERCIAL_PKG
 -> tests/compile/COMP-002_programming_rules_commercial.sql
 -> tests/programming/PRG-910_rules_engine.sql
```

## 5. Known traceability gaps

Still requiring dedicated requirements/tests/evidence:

- territorial/contextual rights evaluation;
- full generic TPS_POLICY/TPS_RULE evaluator;
- local/network programming percentage quotas;
- competitor/category advertising conflicts;
- timezone/DST behavior;
- AI/API request idempotency;
- live source-health state and continuity integration;
- weighted/per-domain D3KA coverage;
- runtime grants/no-direct-DML enforcement;
- Graph/VECTOR/Select AI actual production capability;
- backup/rebuild/restore drills;
- final performance/concurrency SLOs;
- business-owner approval of engineering-provisional names.

No gap is closed by prose alone; closure requires source/test/evidence as applicable.
