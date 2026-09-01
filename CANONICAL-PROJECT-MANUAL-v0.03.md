# TPS_INTELLIGENCE_CORE_01 — CANONICAL PROJECT MANUAL v0.03

## 0. Purpose and authority

This document is the single recovery entry point for the `TPS_INTELLIGENCE_CORE_01` repository. If the chat history is lost, a new engineer or assistant must be able to reopen this repository, read this file first, and reconstruct the project without inventing names, architecture, scope, status or deployment state.

This file does **not** authorize production execution. `TPSDBCORE01` is a production Oracle AI Database 26ai database. Repository source and deployed runtime state are separate authorities.

Authority precedence for this release:

1. `CANONICAL-PROJECT-MANUAL-v0.03.md` — recovery entry point and current map.
2. `docs/00-governance/NAMING-AND-IDENTITY-REGISTER-v0.03.md` — names, aliases, ownership and name status.
3. `PROJECT-MAP.md` — workstreams and CORE gates.
4. `TRACEABILITY-MAP.md` — business requirement -> source -> test -> evidence.
5. `docs/03-architecture/MASTER-DATABASE-ENGINEERING-SPEC-v0.02.md` — system architecture.
6. `docs/04-d3ka/D3KA-ENGINEERING-SPEC-v0.02.md` — tensor/D3KA engineering.
7. `docs/03-architecture/PLSQL-CALL-GRAPH-v0.03.md` — implemented PL/SQL call paths.
8. `docs/06-data-dictionary/SOURCE-ROUTINE-DEPENDENCY-CATALOG-v0.03.md` — current source/routine catalog.
9. `migrations/Vxxxx/*` — immutable change units.
10. `src/*` — executable/declarative implementation source.
11. `tests/*` — executable validation.
12. `docs/15-evidence/*` — evidence state; no PASS without proof.

Older documents remain historical references when explicitly marked superseded. They must not silently override a later authority file.

---

# 1. System identity

| Item | Value | Status/origin |
|---|---|---|
| Repository | `TPS_INTELLIGENCE_CORE_01` | USER_CANONICAL |
| Production database/service identity | `TPSDBCORE01` / `TPS_INTELLIGENCE_CORE_01` | USER_CANONICAL |
| Environment | `PRODUCTION` | USER_CANONICAL / ADR-0002 |
| Current capacity tier | Always Free | capacity/billing property only |
| Platform target | Oracle AI Database 26ai / Autonomous AI Transaction Processing | project architecture |
| Project title used in source headers | `TPS MEDIA INTELLIGENCE FABRIC CORE` | ENGINEERING_PROVISIONAL pending owner naming approval |
| Dominant knowledge model | D3KA / dynamic sparse logical tensor | ACCEPTED architecture |
| D3KA coverage target | >= 90% eligible semantic knowledge coverage | ACCEPTED requirement |

No engineer may rename the repository, production database identity, canonical object family or public contract without the naming/change process in `NAMING-AND-IDENTITY-REGISTER-v0.03.md`.

---

# 2. Mission

Build and operate the production corporate intelligence and data core for a group of radio and television broadcasters, networks, channels, affiliates and repeaters, supporting shared and local programming, media assets, advertising, rights, audience, editorial, operational references, applications and AI.

The database is not merely a collection of station tables. It is intended to be:

- the canonical relational authority;
- a D3KA/knowledge tensor authority;
- an Oracle Property Graph projection authority;
- a temporal/contextual knowledge engine;
- a vector semantic layer;
- a deterministic policy/rule execution layer;
- an auditable AI/agent control plane;
- an API/read-model source of truth;
- a recoverable and certifiable production system.

---

# 3. Fundamental architecture

## 3.1 One relational authority

Authoritative state is stored once in the canonical relational model. Graph, JSON Duality, VECTOR, RAG and AI project or enrich the relational authority; they must not become competing uncontrolled sources of truth.

## 3.2 D3KA

Fundamental logical coordinate:

```text
D3KA(S,R,T)
S = source entity
R = governed relation type
T = target entity
```

Orthogonal dimensions:

```text
C  = context
Tv = valid/event time
To = observed/recorded time
P  = properties
V  = vector representation
E  = evidence/provenance
Q  = confidence/verification
A  = policy/authorization
```

The model is logically tensor-first but physically sparse and relationally governed; it is not implemented as a dense three-dimensional array.

## 3.3 AI authority invariant

```text
AI_RECOMMENDATION != AUTHORIZED_OPERATION
```

AI may read, rank, propose and, when explicitly delegated, perform bounded automation through defined tools. Protected operations remain subject to database-enforced deterministic packages, rights, policy, security, transactions and audit.

---

# 4. Repository structure

```text
README.md
CANONICAL-PROJECT-MANUAL-v0.03.md
PROJECT-MAP.md
DOCUMENTATION-MAP.md
SOURCE-MAP.md
TRACEABILITY-MAP.md

/docs
  /00-governance
  /01-business
  /02-requirements
  /03-architecture
  /04-d3ka
  /05-domain
  /06-data-dictionary
  /07-ai
  /07-ai-ml
  /08-api
  /09-security
  /10-performance
  /11-testing
  /12-operations
  /13-migrations
  /14-compliance
  /15-evidence
  /16-decisions
  /17-research

/src
  /00-precheck
  /02-kernel
  /03-d3ka
  /04-context
  /05-temporal
  /06-graph
  /07-vector
  /08-knowledge
  /09-event
  /10-policy
  /11-ai
  /12-media
  /13-commercial
  /14-rights
  /15-audience
  /16-editorial
  /17-api
  /18-observability
  /19-admin
  /20-reference
  /21-indexes
  /26-certification

/migrations
  /V0001
  /V0002
  /V0003

/tests
  compile, D3KA, graph, vector, AI, security, performance,
  recovery, programming, commercial, temporal, regression, fixtures
```

Directory names are architectural grouping names, not independent database schemas unless a future approved ADR explicitly says otherwise.

---

# 5. Current migration history

## V0001 — Canonical Kernel Bootstrap

Status: DESIGN COMPLETE / NOT EXECUTED.

Scope includes core entity/source/context, D3KA relation kernel, vectors, assertions, events, policy, AI metadata, audit structures, graph projection, media/domain structures and reference dictionaries.

V0001 cannot be called deployed until production evidence proves it.

## V0002 — Programming + AI Capability Guard + 24x7 Continuity

Status: SOURCE BUILT / NOT DEPLOYED / RUNTIME COMPILE NOT PROVEN.

Introduces:

- `TPS_AI_AGENT_TOOL`;
- `TPS_AI_GUARD_PKG`;
- `TPS_PROGRAMMING_PKG`;
- `TPS_CONTINUITY_DECISION`;
- `TRG_TPS_CONT_DECISION_IMMUTABLE`;
- `TPS_CONTINUITY_PKG`;
- `TPS_AI_PROGRAMMING_TOOL_PKG`;
- canonical AI tool reference `TPS_PROGRAMMING_TOOL`.

Primary runtime path:

```text
AI/HUMAN/API
 -> AI guard when AI
 -> TPS_PROGRAMMING_PKG
 -> media availability
 -> rights
 -> schedule state
 -> continuity
 -> D3KA affiliate/network lookup
 -> immutable decision evidence
```

## V0003 — Programming Rules + Commercial Authorization

Status: SOURCE BUILT / NOT DEPLOYED / RUNTIME COMPILE NOT PROVEN.

Introduces:

- `TPS_CONTENT_RATING`;
- `TPS_PROGRAMMING_RULE_PROFILE`;
- `TPS_PROGRAMMING_RULES_PKG`;
- `TRG_TPS_SCHEDULE_POLICY_GUARD`;
- `TPS_COMMERCIAL_PKG`;
- Brazilian content-rating seed source;
- compile and rollback-only functional tests.

Implemented rule classes:

- repeat-window detection;
- commercial seconds per rolling hour;
- content minimum-age/rating enforcement;
- required program rating;
- media duration tolerance;
- authorized placement requirement;
- campaign validity;
- creative media availability;
- commercial broadcast rights;
- campaign frequency limit;
- fail-closed schedule approval/activation.

---

# 6. Implemented PL/SQL package contracts

## TPS_D3KA_PKG

Public routines:

- `ASSERT_RELATION`
- `END_RELATION`
- `ACTIVE_RELATION_COUNT`

Responsibility: controlled D3KA relation creation/lifecycle/lookup.

## TPS_TEMPORAL_PKG

- `INTERVAL_CONTAINS`
- `INTERVALS_OVERLAP`

Responsibility: shared half-open `[from,to)` temporal semantics.

## TPS_RIGHTS_PKG

- `DECISION_FOR`

Responsibility: deterministic ALLOW/DENY/UNKNOWN rights decision.

Known limitation: stored territory/context fields are not yet fully enforced by the current package implementation.

## TPS_POLICY_ENGINE_PKG

- `AUTHORIZE_CONTENT_ACTION`

Known limitation: current body delegates to rights and does not yet evaluate the complete generic `TPS_POLICY/TPS_RULE` universe. An ALLOW from the current body is therefore not sufficient to claim final enterprise authorization.

## TPS_AI_GUARD_PKG

- `PERMISSION_ALLOWED`
- `ASSERT_PERMISSION`

Responsibility: enforce AI agent/tool permission mode and temporal grant.

## TPS_AI_PROGRAMMING_TOOL_PKG

- `CONTEXT_SNAPSHOT`
- `PROPOSE_SCHEDULE_ITEM`
- `EXECUTE_BOUNDED_ADD_ITEM`

Responsibility: expose a bounded database tool to AI without arbitrary SQL authority.

## TPS_PROGRAMMING_PKG

- `CREATE_SCHEDULE`
- `ADD_SCHEDULE_ITEM`
- `VALIDATION_REPORT`
- `APPROVE_SCHEDULE`
- `ACTIVATE_SCHEDULE`
- `ITEM_IS_PLAYABLE`
- `CURRENT_ITEM`
- `NEXT_ITEM`

Responsibility: transactional programming authority. `ADD_SCHEDULE_ITEM` locks schedule rows with `SELECT ... FOR UPDATE`, rejects overlap, verifies media and rights, and does not commit.

## TPS_CONTINUITY_PKG

- `RESOLVE_NETWORK_ENTITY`
- `RESOLVE_PLAYOUT`

Responsibility: 24x7 continuity/fallback, including D3KA `REPEATS` / `AFFILIATED_WITH` parent-network resolution.

## TPS_PROGRAMMING_RULES_PKG

- `REPEAT_VIOLATION_COUNT`
- `COMMERCIAL_SECONDS_ROLLING_HOUR`
- `SCHEDULE_REPORT`
- `ASSERT_SCHEDULE_RULES`

Responsibility: database-enforced broadcaster programming policy before schedule approval/activation.

## TPS_COMMERCIAL_PKG

- `PLACEMENT_DECISION`
- `AUTHORIZE_PLACEMENT`
- `MARK_PLAYED`

Responsibility: deterministic commercial placement authorization/lifecycle.

---

# 7. Trigger policy

Business workflow is primarily implemented in explicit packages. Triggers are reserved for integrity/guard/evidence cases where bypass resistance is required.

Currently intentional triggers:

- `TRG_TPS_CONT_DECISION_IMMUTABLE` — forbids UPDATE/DELETE of continuity evidence.
- `TRG_TPS_SCHEDULE_POLICY_GUARD` — prevents an invalid schedule from transitioning to APPROVED/ACTIVE outside the package path.

Any future trigger must document event, timing, affected tables, recursion risk, lock/transaction impact, errors and tests.

---

# 8. Source documentation rule

Every executable source must contain embedded documentation covering:

- file/object identity;
- purpose and business impact;
- dependencies/upstream/downstream;
- D3KA role and links;
- AI role;
- security;
- performance;
- transaction/locking;
- idempotency;
- failure modes;
- rollback/recovery;
- tests/evidence;
- references;
- change history.

Every PL/SQL routine must additionally document inputs, outputs, reads, writes, calls, callers, errors, transaction behavior, performance and tests.

The authoritative contract is `docs/06-data-dictionary/SOURCE-EMBEDDED-DOCUMENTATION-CONTRACT-v0.02.md` until superseded by a later approved revision.

---

# 9. Naming governance

Names created during engineering are not automatically owner-approved business terminology. `docs/00-governance/NAMING-AND-IDENTITY-REGISTER-v0.03.md` classifies names as:

- `USER_CANONICAL` — explicitly supplied/approved by project owner;
- `ENGINEERING_PROVISIONAL` — technical name introduced during engineering and not yet owner-approved;
- `APPROVED_CANONICAL` — owner-approved technical/business name;
- `ALIAS_LEGACY` — historical alias retained only for traceability;
- `DEPRECATED` — no new use.

No provisional name may be silently described as a user decision.

---

# 10. Recovery from loss of chat/context

If conversation state is lost:

1. open `CANONICAL-PROJECT-MANUAL-v0.03.md`;
2. read `NAMING-AND-IDENTITY-REGISTER-v0.03.md`;
3. read `ENGINEERING-STATE-LEDGER-v0.03.md`;
4. read `PROJECT-MAP.md` and `TRACEABILITY-MAP.md`;
5. read `SOURCE-ROUTINE-DEPENDENCY-CATALOG-v0.03.md`;
6. inspect migrations in numerical order;
7. never infer production deployment from repository HEAD;
8. obtain production runtime evidence before claiming any object is deployed/VALID;
9. continue from the first open gate in the state ledger.

The repository, not a chat transcript, is the recovery authority.

---

# 11. Current known engineering gaps

The following remain explicitly open:

- runtime compile of V0001/V0002/V0003 against TPSDBCORE01;
- `USER_ERRORS=0` evidence;
- functional runtime tests;
- complete runtime least-privilege role/grant model;
- territory/context enforcement in rights decisions;
- full generic `TPS_POLICY/TPS_RULE` evaluation;
- competitor-category advertising conflict rules;
- local/network programming percentage quotas;
- timezone/DST schedule tests;
- request/idempotency ledger for AI/API retries;
- live-source health integration for continuity;
- Graph/VECTOR/AI runtime compatibility proof;
- weighted and per-domain D3KA >=90% certification;
- performance/concurrency baselines;
- backup/rebuild/restore evidence;
- remaining source embedded-documentation retrofit;
- final owner review of engineering-provisional names.

Unknown/unproven items stay explicitly UNKNOWN/NOT_PROVEN.

---

# 12. Definition of completion

The project is not complete because source exists. A capability is complete only when business purpose, requirements, names, data semantics, D3KA mapping, physical design, source, routines, tests, security, performance, operations, recovery, deployment evidence and certification are all documented and linked.

Final authority remains the project owner's approved requirements plus evidence from the actual production database.
