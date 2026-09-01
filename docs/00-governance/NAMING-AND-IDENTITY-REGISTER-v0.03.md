# TPS_INTELLIGENCE_CORE_01 — NAMING AND IDENTITY REGISTER v0.03

## 1. Purpose

This register prevents silent invention, renaming or reinterpretation of project names, database identities, business terms, source objects and public contracts.

Every important name must have an origin and status.

## 2. Status vocabulary

- `USER_CANONICAL` — explicitly supplied or confirmed by the project owner.
- `APPROVED_CANONICAL` — technical/business name reviewed and approved by the project owner.
- `ENGINEERING_PROVISIONAL` — name introduced during engineering; usable in source while NOT DEPLOYED but not represented as owner-approved.
- `ALIAS_LEGACY` — historical alias retained for traceability only.
- `DEPRECATED` — no new use; replacement must be documented.
- `REJECTED` — must not be used.

## 3. Rename rule

No `USER_CANONICAL` or `APPROVED_CANONICAL` identifier may be renamed without:

1. explicit owner approval;
2. ADR describing why;
3. dependency/search impact;
4. database migration plan if deployed;
5. API/consumer compatibility analysis;
6. test updates;
7. documentation updates;
8. rollback/recovery strategy;
9. evidence.

A repository commit is not naming approval by itself.

## 4. Core project identities

| Identifier | Meaning | Origin/status | Notes |
|---|---|---|---|
| `TPS_INTELLIGENCE_CORE_01` | GitHub repository and OCI display identity used by project | USER_CANONICAL | Do not rename silently. |
| `TPSDBCORE01` | production database/service shorthand | USER_CANONICAL | Environment = PRODUCTION. |
| `TPS MEDIA INTELLIGENCE FABRIC CORE` | long project title currently used in source headers | ENGINEERING_PROVISIONAL | Requires owner confirmation or replacement. |
| `D3KA` | Dynamic Three-Dimensional Knowledge Array terminology | USER/PROJECT_CANONICAL | Fundamental logical model. |
| `TPS` prefix | project database object namespace | ENGINEERING_PROVISIONAL | Widely used in source; owner approval still to be explicitly recorded. |

## 5. Architectural names

| Name | Purpose | Status |
|---|---|---|
| `TPS_ENTITY_TYPE` | governed entity type taxonomy | ENGINEERING_PROVISIONAL |
| `TPS_ENTITY` | universal canonical identity | ENGINEERING_PROVISIONAL |
| `TPS_PROPERTY` | extensible entity property history | ENGINEERING_PROVISIONAL |
| `TPS_SOURCE` | provenance/evidence source registry | ENGINEERING_PROVISIONAL |
| `TPS_RELATION_TYPE` | D3KA R-axis ontology | ENGINEERING_PROVISIONAL |
| `TPS_RELATION` | persisted sparse D3KA relation/cell backbone | ENGINEERING_PROVISIONAL |
| `TPS_CONTEXT_TYPE` | context dimension taxonomy | ENGINEERING_PROVISIONAL |
| `TPS_CONTEXT` | context instances | ENGINEERING_PROVISIONAL |
| `TPS_MEDIA_KNOWLEDGE_GRAPH` | Oracle Property Graph projection | ENGINEERING_PROVISIONAL |
| `TPS_VECTOR_TYPE` | semantic vector-space taxonomy | ENGINEERING_PROVISIONAL |
| `TPS_VECTOR` | multivector entity embeddings | ENGINEERING_PROVISIONAL |
| `TPS_ASSERTION` | provenance-bearing knowledge claims | ENGINEERING_PROVISIONAL |
| `TPS_EVENT_TYPE` | event taxonomy | ENGINEERING_PROVISIONAL |
| `TPS_EVENT` | event ledger | ENGINEERING_PROVISIONAL |
| `TPS_POLICY` | policy identity/lifecycle | ENGINEERING_PROVISIONAL |
| `TPS_RULE` | deterministic rule definitions | ENGINEERING_PROVISIONAL |
| `TPS_AI_MODEL` | AI/ML model registry | ENGINEERING_PROVISIONAL |
| `TPS_AI_AGENT` | AI agent registry | ENGINEERING_PROVISIONAL |
| `TPS_AI_TOOL` | AI tool registry | ENGINEERING_PROVISIONAL |
| `TPS_AI_DECISION` | AI decision/audit ledger | ENGINEERING_PROVISIONAL |

## 6. Media/programming names

| Name | Purpose | Status |
|---|---|---|
| `TPS_STATION` | station domain projection | ENGINEERING_PROVISIONAL |
| `TPS_CHANNEL` | channel domain projection | ENGINEERING_PROVISIONAL |
| `TPS_PROGRAM` | program metadata | ENGINEERING_PROVISIONAL |
| `TPS_SCHEDULE` | schedule identity/lifecycle | ENGINEERING_PROVISIONAL |
| `TPS_SCHEDULE_ITEM` | timeline programming item | ENGINEERING_PROVISIONAL |
| `TPS_MEDIA_ASSET` | media technical/identity metadata | ENGINEERING_PROVISIONAL |
| `TPS_PROGRAMMING_PKG` | deterministic schedule transaction engine | ENGINEERING_PROVISIONAL |
| `TPS_CONTINUITY_DECISION` | append-only continuity decision evidence | ENGINEERING_PROVISIONAL |
| `TPS_CONTINUITY_PKG` | 24x7 continuity/fallback engine | ENGINEERING_PROVISIONAL |
| `TPS_CONTENT_RATING` | content classification/rating reference | ENGINEERING_PROVISIONAL |
| `TPS_PROGRAMMING_RULE_PROFILE` | temporal programming rules per owner entity | ENGINEERING_PROVISIONAL |
| `TPS_PROGRAMMING_RULES_PKG` | deterministic extended schedule-rule engine | ENGINEERING_PROVISIONAL |

## 7. Rights/commercial names

| Name | Purpose | Status |
|---|---|---|
| `TPS_RIGHT_GRANT` | explicit temporal rights ALLOW/DENY grant | ENGINEERING_PROVISIONAL |
| `TPS_RIGHTS_PKG` | deterministic rights decision | ENGINEERING_PROVISIONAL |
| `TPS_CAMPAIGN` | advertising campaign projection | ENGINEERING_PROVISIONAL |
| `TPS_PLACEMENT` | planned/authorized/played commercial placement | ENGINEERING_PROVISIONAL |
| `TPS_COMMERCIAL_PKG` | deterministic commercial authorization/lifecycle | ENGINEERING_PROVISIONAL |

## 8. AI control-plane names

| Name | Purpose | Status |
|---|---|---|
| `TPS_AI_AGENT_TOOL` | temporal agent-to-tool permission relation | ENGINEERING_PROVISIONAL |
| `TPS_AI_GUARD_PKG` | database-enforced AI capability guard | ENGINEERING_PROVISIONAL |
| `TPS_AI_PROGRAMMING_TOOL_PKG` | bounded AI programming tool wrapper | ENGINEERING_PROVISIONAL |
| `TPS_PROGRAMMING_TOOL` | canonical tool key seeded for AI programming capability | ENGINEERING_PROVISIONAL |
| `ANALYTICS_ONLY` | AI authority class | ENGINEERING_PROVISIONAL |
| `ADVISORY` | AI authority class | ENGINEERING_PROVISIONAL |
| `BOUNDED_AUTOMATION` | AI authority class | ENGINEERING_PROVISIONAL |
| `READ` | tool permission mode | ENGINEERING_PROVISIONAL |
| `PROPOSE` | tool permission mode | ENGINEERING_PROVISIONAL |
| `EXECUTE_BOUNDED` | tool permission mode | ENGINEERING_PROVISIONAL |

## 9. D3KA relation codes currently seeded or referenced

All relation codes are engineering vocabulary pending business/ontology review unless separately approved.

Current examples include:

`OWNS`, `OPERATES`, `MANAGES`, `BELONGS_TO`, `AFFILIATED_WITH`, `REPEATS`, `BROADCASTS`, `PRESENTS`, `PRODUCES`, `DIRECTS`, `PERFORMS`, `COMPOSED`, `AUTHORED`, `FEATURES`, `PLAYED_ON`, `SCHEDULED_ON`, `TARGETS`, `SPONSORED_BY`, `LICENSED_BY`, `AUTHORIZED_FOR`, `PROHIBITED_IN`, `AVAILABLE_IN`, `POPULAR_IN`, `SIMILAR_TO`, `INFLUENCED_BY`, `MENTIONS`, `REFERENCES`, `DERIVED_FROM`, `GENERATED_BY`, `CLASSIFIED_AS`, `RECOMMENDED_FOR`, `MASTER_OF`, `PROXY_OF`, `TRANSCODED_FROM`, `THUMBNAIL_OF`, `AUDIO_OF`, `VIDEO_OF`, `SUBTITLE_OF`, `TRANSCRIPT_OF`, `SERVES_REGION`, `COMPETES_WITH`, `PROMOTES`, `AI_RECOMMENDED`.

Status for this vocabulary: `ENGINEERING_PROVISIONAL` until the ontology/business dictionary is reviewed.

## 10. Migration names

| Migration | Meaning | Status |
|---|---|---|
| `V0001 — Canonical Kernel Bootstrap` | initial core schema/source bootstrap | ENGINEERING_PROVISIONAL title; migration ID stable |
| `V0002 — Programming + AI Capability Guard + 24x7 Continuity` | first PL/SQL vertical slice | ENGINEERING_PROVISIONAL title; migration ID stable |
| `V0003 — Programming Rules + Commercial Authorization` | extended broadcaster/commercial policy | ENGINEERING_PROVISIONAL title; migration ID stable |

Migration IDs are immutable once referenced. Human-readable titles may be corrected before deployment if change is documented.

## 11. Naming review backlog

Owner review is still required for:

- long project title;
- `TPS` object namespace;
- object/package names introduced by engineering;
- schedule terminology (`owner_entity`, `schedule_class`, `item_class`, etc.);
- AI authority-class terminology;
- D3KA relation ontology vocabulary;
- commercial terminology;
- continuity decision codes;
- content-rating vocabulary and regulatory naming.

Until reviewed, documentation must say `ENGINEERING_PROVISIONAL`; it must not say that the owner chose those names.
