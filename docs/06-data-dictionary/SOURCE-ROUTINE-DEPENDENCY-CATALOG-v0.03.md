# TPSDBCORE01 — SOURCE, ROUTINE AND DEPENDENCY CATALOG v0.03

## 1. Purpose

This catalog records the current database source families, their responsibility, direct dependency class, consumers/tests and repository/runtime state. It exists so a future engineer can understand why each source exists without reconstructing the architecture from chat history.

Status vocabulary used here:

- `SOURCE_EXISTS` — file exists in repository.
- `SOURCE_READY_PENDING_RUNTIME` — source is designed/documented but runtime compilation/behavior is not yet proven.
- `REFERENCE_SOURCE` — governed seed/reference source; execution is still a production mutation.
- `READ_ONLY` — discovery/certification source.
- `TEMPLATE` — source template requiring capability/security/change gate before use.

Unless explicitly evidenced elsewhere, all sources below have `PRODUCTION_STATE=NOT_DEPLOYED/NOT_PROVEN`.

---

# 2. Read-only precheck sources

| Path | Responsibility | Dependencies | Consumer/gate |
|---|---|---|---|
| `src/00-precheck/000_database_identity.sql` | database/session/version/charset identity | Oracle dictionary | CORE-00 |
| `src/00-precheck/010_feature_inventory.sql` | visible Oracle features/packages | V$OPTION, ALL_OBJECTS | CORE-01 |
| `src/00-precheck/020_privilege_inventory.sql` | effective roles/system/object privileges | session/dictionary privilege views | CORE-02/18 |
| `src/00-precheck/030_graph_capability.sql` | Property Graph capability discovery | ALL_OBJECTS/ALL_VIEWS | CORE-01/05 |
| `src/00-precheck/040_vector_capability.sql` | VECTOR constructor/package discovery | VECTOR, dictionary | CORE-01/08 |
| `src/00-precheck/050_json_duality_capability.sql` | JSON/Duality discovery | JSON SQL/dictionary | CORE-01/13 |
| `src/00-precheck/060_ai_capability.sql` | Select AI/agent package discovery | DBMS_CLOUD_AI metadata | CORE-01/10/16 |
| `src/00-precheck/070_audit_capability.sql` | unified-audit capability discovery | audit metadata | CORE-01/12/18 |
| `src/00-precheck/080_capacity_snapshot.sql` | runtime/tablespace capacity baseline | V$SYSMETRIC, DBA usage views | CORE-00/17 |

All nine must remain read-only.

---

# 3. Universal identity kernel

| Path | Object | Responsibility | Direct dependencies | Major consumers |
|---|---|---|---|---|
| `src/02-kernel/200_tps_entity_type.sql` | `TPS_ENTITY_TYPE` | entity taxonomy | self-reference | TPS_ENTITY, relation ontology |
| `src/02-kernel/210_tps_entity.sql` | `TPS_ENTITY` | universal canonical identity | TPS_ENTITY_TYPE | D3KA, domains, Graph, API, AI |
| `src/02-kernel/220_tps_property.sql` | `TPS_PROPERTY` | temporal extensible entity properties | TPS_ENTITY | API/AI/knowledge |
| `src/02-kernel/230_tps_source.sql` | `TPS_SOURCE` | provenance/evidence source registry | TPS_ENTITY optional | relation/assertion/AI evidence |

---

# 4. D3KA/tensor kernel

| Path | Object | Responsibility | Direct dependencies | Tests/consumers |
|---|---|---|---|---|
| `src/03-d3ka/300_tps_relation_type.sql` | `TPS_RELATION_TYPE` | governed R-axis ontology | TPS_ENTITY_TYPE | D3KA package, graph |
| `src/03-d3ka/310_tps_relation.sql` | `TPS_RELATION` | persisted sparse S/R/T cell + C/T/E/Q/P | entity, relation type, context, source | D3KA, graph, continuity, RAG |
| `src/03-d3ka/320_tps_d3ka_pkg.pks` | `TPS_D3KA_PKG` spec | public governed relation API | relation/entity ontology | D3KA tests |
| `src/03-d3ka/321_tps_d3ka_pkg.pkb` | `TPS_D3KA_PKG` body | relation validation/write/lifecycle/count | TPS_RELATION/ENTITY/RELATION_TYPE | D3KA tests |
| `src/03-d3ka/330_d3ka_projection_views.sql` | D3KA active/history views | relational tensor projections | relation/entity/type | slices/APIs |
| `src/03-d3ka/340_d3ka_invariants.sql` | invariant violation view | detect selected semantic corruption | relation/type | D3KA-010 |
| `src/03-d3ka/350_tps_fact_class.sql` | `TPS_FACT_CLASS` | governed semantic coverage denominator | none | CORE-15 |
| `src/03-d3ka/351_tps_fact_class_mapping.sql` | `TPS_FACT_CLASS_MAPPING` | map fact classes to physical representation | fact class/relation type | CORE-15 |
| `src/03-d3ka/360_d3ka_coverage_v.sql` | coverage view | preliminary unweighted D3KA coverage | fact classes/mappings | D3KA-011 |

Known limitation: current coverage view is not sufficient for final >=90% certification because weighted and per-domain coverage remain required.

## TPS_D3KA_PKG routines

### `ASSERT_RELATION`

Purpose: validate relation ontology and insert one S/R/T cell. Reads relation type and source/target entities; writes TPS_RELATION; no commit. Errors include self-relation/type/context/provenance/confidence failures. Tests: D3KA-001 through D3KA-005.

### `END_RELATION`

Purpose: close an active/open relation without deleting history. Writes state/VALID_TO; no commit. Fail closed if exactly one active relation is not found.

### `ACTIVE_RELATION_COUNT`

Purpose: read S/R or S/R/T active/open slice count. Read-only.

Private body helper `RELATION_TYPE_ID` resolves an active relation code to the internal relation type ID.

---

# 5. Context and temporal engine

| Path | Object | Responsibility | Dependencies | Consumers |
|---|---|---|---|---|
| `src/04-context/400_tps_context_type.sql` | `TPS_CONTEXT_TYPE` | context taxonomy | none | TPS_CONTEXT |
| `src/04-context/410_tps_context.sql` | `TPS_CONTEXT` | typed temporal context instances | context type | D3KA/rights/events |
| `src/05-temporal/500_tps_relation_current_v.sql` | `TPS_RELATION_CURRENT_V` | strict current-valid relation projection | TPS_RELATION | current graph/API logic |
| `src/05-temporal/510_tps_temporal_pkg.pks` | `TPS_TEMPORAL_PKG` spec | common temporal predicates | none | domain rules |
| `src/05-temporal/511_tps_temporal_pkg.pkb` | package body | half-open interval implementation | spec | temporal tests |

## TPS_TEMPORAL_PKG routines

- `INTERVAL_CONTAINS(from,to,at)` -> 1/0 using `[from,to)` semantics.
- `INTERVALS_OVERLAP(a_from,a_to,b_from,b_to)` -> 1/0 using half-open intervals.

Both are deterministic/read-only.

---

# 6. Property Graph

| Path | Object | Responsibility | Dependencies | Consumers |
|---|---|---|---|---|
| `src/06-graph/600_tps_media_knowledge_graph.sql` | `TPS_MEDIA_KNOWLEDGE_GRAPH` | Oracle Property Graph: entity vertices/relation edges | TPS_ENTITY/TPS_RELATION | SQL/PGQ, Graph RAG |
| `src/06-graph/610_tps_graph_neighbors_v.sql` | `TPS_GRAPH_NEIGHBORS_V` | one-hop directed graph projection | property graph | graph/RAG/tests |

Known limitation: current neighbor view filters relation lifecycle state but is not equivalent to strict current-valid-time filtering.

---

# 7. VECTOR semantic layer

| Path | Object | Responsibility | Dependencies | Consumers |
|---|---|---|---|---|
| `src/07-vector/700_tps_vector_type.sql` | `TPS_VECTOR_TYPE` | semantic vector-space/metric taxonomy | none | TPS_VECTOR |
| `src/07-vector/710_tps_vector.sql` | `TPS_VECTOR` | model/versioned multivector embeddings per entity | entity/vector type/VECTOR | RAG/recommendation |
| `src/07-vector/720_vector_similarity_queries.sql` | exact top-K query template | cosine exact-search baseline | TPS_VECTOR | vector tests/ANN baseline |
| `src/21-indexes/2100_vector_hnsw_template.sql` | HNSW index template | approximate vector index candidate | TPS_VECTOR | performance tests |
| `src/21-indexes/2110_vector_ivf_template.sql` | IVF index template | approximate vector index candidate | TPS_VECTOR | performance tests |

Known limitations: exact template is cosine-specific; ANN templates require runtime capability/recall/performance proof.

---

# 8. Knowledge and events

| Path | Object | Responsibility | Dependencies | Consumers |
|---|---|---|---|---|
| `src/08-knowledge/810_tps_assertion.sql` | `TPS_ASSERTION` | provenance-bearing claims/inferences | entity/relation type/source | RAG/verification/AI |
| `src/09-event/900_tps_event_type.sql` | `TPS_EVENT_TYPE` | event taxonomy | none | TPS_EVENT |
| `src/09-event/910_tps_event.sql` | `TPS_EVENT` | append-oriented event occurrence ledger | event type/entity/context/source | analytics/audit/ML |

Known event gap: retry/idempotency and large-scale retention/partitioning remain to be designed and proven.

---

# 9. Policy and rights

| Path | Object | Responsibility | Dependencies | Consumers |
|---|---|---|---|---|
| `src/10-policy/1000_tps_policy.sql` | `TPS_POLICY` | policy identity/priority/temporal lifecycle | none | policy engine |
| `src/10-policy/1010_tps_rule.sql` | `TPS_RULE` | deterministic rule definitions | TPS_POLICY | future generic evaluator |
| `src/10-policy/1020_tps_policy_engine_pkg.pks` | `TPS_POLICY_ENGINE_PKG` spec | content-action authorization contract | rights package | API/AI/action gates |
| `src/10-policy/1030_tps_policy_engine_pkg.pkb` | package body | current rights-layer fail-closed authorization | TPS_RIGHTS_PKG | action gate |
| `src/14-rights/1400_tps_right_grant.sql` | `TPS_RIGHT_GRANT` | temporal ALLOW/DENY rights grants | entity/context/source | rights package |
| `src/14-rights/1410_tps_rights_pkg.pks` | `TPS_RIGHTS_PKG` spec | rights decision contract | right grants | programming/commercial |
| `src/14-rights/1420_tps_rights_pkg.pkb` | package body | DENY > ALLOW > UNKNOWN decision | right grants | policy/programming/commercial |

## TPS_RIGHTS_PKG routine

`DECISION_FOR(content,beneficiary,action,at)` returns `DENY`, else `ALLOW`, else `UNKNOWN`. UNKNOWN is never permission.

Known limitation: territory and context columns exist on right grants but are not yet fully enforced by the current decision routine.

## TPS_POLICY_ENGINE_PKG routine

`AUTHORIZE_CONTENT_ACTION(...)` currently delegates to rights. It does not yet implement full generic TPS_POLICY/TPS_RULE evaluation and therefore cannot be described as complete enterprise authorization.

---

# 10. AI registry and AI control-plane source

## Original AI registry/templates

| Path | Responsibility |
|---|---|
| `src/11-ai/1100_tps_ai_model.sql` | AI/ML model registry |
| `src/11-ai/1110_tps_ai_agent.sql` | agent registry/authority metadata |
| `src/11-ai/1120_tps_ai_tool.sql` | tool registry |
| `src/11-ai/1130_tps_ai_decision.sql` | AI decision/audit ledger |
| `src/11-ai/1140_graph_rag_neighbors.sql` | graph-aware retrieval source |
| `src/11-ai/1150_select_ai_profile_template.sql` | Select AI profile template; production mutation if executed |
| `src/11-ai/1160_agent_program_director_template.sql` | agent template; production mutation if executed |
| `src/11-ai/1170_agent_sql_tool_template.sql` | SQL tool template; textual instructions are not security control |
| `src/11-ai/1180_agent_task_template.sql` | agent task template |

## V0002 AI control-plane

| Path | Object | Responsibility | Dependencies |
|---|---|---|---|
| `src/11-ai/1190_tps_ai_agent_tool.sql` | `TPS_AI_AGENT_TOOL` | temporal agent/tool permission mapping | AI agent/tool |
| `src/11-ai/1191_tps_ai_guard_pkg.pks` | `TPS_AI_GUARD_PKG` spec | permission contract | agent/tool/grant |
| `src/11-ai/1192_tps_ai_guard_pkg.pkb` | package body | enforce agent/tool/mode/time/authority | same |
| `src/11-ai/1193_tps_ai_programming_tool_pkg.pks` | `TPS_AI_PROGRAMMING_TOOL_PKG` spec | bounded programming tool contract | guard/programming/continuity |
| `src/11-ai/1194_tps_ai_programming_tool_pkg.pkb` | package body | context/proposal/bounded execution | guard/programming/AI decision |

### TPS_AI_GUARD_PKG routines

- `PERMISSION_ALLOWED` — read-only capability decision.
- `ASSERT_PERMISSION` — fail-closed permission assertion.

Authority matrix:

```text
ANALYTICS_ONLY: READ
ADVISORY: READ + PROPOSE
BOUNDED_AUTOMATION: READ + PROPOSE + EXECUTE_BOUNDED
```

These names are engineering-provisional until owner review.

### TPS_AI_PROGRAMMING_TOOL_PKG routines

- `CONTEXT_SNAPSHOT` — requires READ, returns programming/network context JSON.
- `PROPOSE_SCHEDULE_ITEM` — requires PROPOSE, writes an AI decision/proposal but not schedule state.
- `EXECUTE_BOUNDED_ADD_ITEM` — requires EXECUTE_BOUNDED; uses local SAVEPOINT, calls deterministic programming package, records AI decision, rolls back bounded work on any downstream failure; no commit.

---

# 11. Media/broadcast domain base tables

| Path | Object | Responsibility | Main dependencies/consumers |
|---|---|---|---|
| `src/12-media/1200_tps_station.sql` | `TPS_STATION` | station domain projection | TPS_ENTITY; programming/API |
| `src/12-media/1210_tps_channel.sql` | `TPS_CHANNEL` | channel projection | entity/station; programming/API |
| `src/12-media/1220_tps_program.sql` | `TPS_PROGRAM` | program metadata | entity; programming rules |
| `src/12-media/1230_tps_schedule.sql` | `TPS_SCHEDULE` | schedule identity/lifecycle/window/precedence | entity; programming packages |
| `src/12-media/1240_tps_schedule_item.sql` | `TPS_SCHEDULE_ITEM` | timeline content item | schedule/entity/context | programming/continuity/commercial |
| `src/12-media/1250_tps_media_asset.sql` | `TPS_MEDIA_ASSET` | media hash/location/codecs/duration/state | content entity | programming/commercial |

---

# 12. V0002 programming and continuity source

| Path | Object | Responsibility |
|---|---|---|
| `src/12-media/1260_tps_programming_pkg.pks` | `TPS_PROGRAMMING_PKG` spec | transactional schedule API |
| `src/12-media/1261_tps_programming_pkg.pkb` | body | locks, overlap, asset, rights, approval, activation, current/next |
| `src/12-media/1270_tps_continuity_decision.sql` | `TPS_CONTINUITY_DECISION` | append-only continuity decision evidence |
| `src/12-media/1271_tps_continuity_decision_immutable_trg.sql` | `TRG_TPS_CONT_DECISION_IMMUTABLE` | reject UPDATE/DELETE of ledger |
| `src/12-media/1280_tps_continuity_pkg.pks` | `TPS_CONTINUITY_PKG` spec | continuity API |
| `src/12-media/1281_tps_continuity_pkg.pkb` | body | local/emergency/fallback/network resolution |

## TPS_PROGRAMMING_PKG routines

- `CREATE_SCHEDULE` — inserts DRAFT schedule; validates owner/time.
- `ADD_SCHEDULE_ITEM` — `FOR UPDATE` schedule lock, validates DRAFT, time, content, overlap, asset, rights; inserts item; no commit.
- `VALIDATION_REPORT` — returns JSON base validation counts.
- `APPROVE_SCHEDULE` — DRAFT -> APPROVED only after base validation.
- `ACTIVATE_SCHEDULE` — APPROVED -> ACTIVE only after validation and active schedule conflict check.
- `ITEM_IS_PLAYABLE` — read-only eligibility at a time.
- `CURRENT_ITEM` — first current playable candidate by precedence/priority.
- `NEXT_ITEM` — first future playable candidate.

## TPS_CONTINUITY_PKG routines

- `RESOLVE_NETWORK_ENTITY` — resolves current D3KA `REPEATS`/`AFFILIATED_WITH` parent network.
- `RESOLVE_PLAYOUT` — deterministic local -> emergency -> fallback -> network -> network fallback -> NO_PLAYABLE_ITEM decision; appends continuity ledger record.

Private helper `FIND_ITEM` scans bounded candidate schedules/items and asks programming package whether each is playable.

---

# 13. V0003 programming-rule source

| Path | Object | Responsibility |
|---|---|---|
| `src/12-media/1290_tps_content_rating.sql` | `TPS_CONTENT_RATING` | content rating/minimum-age reference |
| `src/12-media/1291_tps_programming_rule_profile.sql` | `TPS_PROGRAMMING_RULE_PROFILE` | temporal per-owner programming hard-rule profile |
| `src/12-media/1292_tps_programming_rules_pkg.pks` | `TPS_PROGRAMMING_RULES_PKG` spec | extended broadcaster rule API |
| `src/12-media/1293_tps_programming_rules_pkg.pkb` | body | repeat/ad-load/rating/duration/placement validation |
| `src/12-media/1294_tps_schedule_policy_guard_trg.sql` | `TRG_TPS_SCHEDULE_POLICY_GUARD` | blocks invalid APPROVED/ACTIVE state transition |

## TPS_PROGRAMMING_RULES_PKG routines

- `REPEAT_VIOLATION_COUNT(schedule_id)` — count repeated content pairs inside configured window.
- `COMMERCIAL_SECONDS_ROLLING_HOUR(owner,window_end)` — compute seconds of commercial items overlapping trailing 60 minutes.
- `SCHEDULE_REPORT(schedule_id)` — JSON hard-rule report across profile, repeat, commercial load, rating, asset duration and placement.
- `ASSERT_SCHEDULE_RULES(schedule_id)` — raise `-20601` unless report is valid.

Trigger purpose: a direct schedule-state update cannot bypass the deterministic package rule gate.

---

# 14. Commercial domain

| Path | Object | Responsibility |
|---|---|---|
| `src/13-commercial/1300_tps_campaign.sql` | `TPS_CAMPAIGN` | campaign validity/frequency/rules state |
| `src/13-commercial/1310_tps_placement.sql` | `TPS_PLACEMENT` | creative/channel/time placement lifecycle |
| `src/13-commercial/1320_tps_commercial_pkg.pks` | `TPS_COMMERCIAL_PKG` spec | authorization/lifecycle API |
| `src/13-commercial/1321_tps_commercial_pkg.pkb` | body | campaign/asset/rights/frequency decision + state changes |

## TPS_COMMERCIAL_PKG routines

- `PLACEMENT_DECISION(placement_id,at)` — returns `ALLOW` or fail-closed `DENY_*` code after campaign/time, asset, rights and frequency evaluation.
- `AUTHORIZE_PLACEMENT(placement_id,at)` — locks PLANNED placement and transitions to AUTHORIZED only on ALLOW; otherwise REJECTED; no commit.
- `MARK_PLAYED(placement_id,event_id)` — AUTHORIZED -> PLAYED and links playback event; no commit.

---

# 15. Audience/editorial/API/observability/admin sources

| Path | Responsibility |
|---|---|
| `src/15-audience/1500_tps_audience_segment.sql` | audience segment projection |
| `src/15-audience/1510_tps_audience_observation.sql` | audience observation/telemetry aggregate source |
| `src/16-editorial/1600_tps_editorial_item.sql` | editorial/news/report/interview/podcast item projection |
| `src/17-api/1700_entity_api_v.sql` | entity API/read projection |
| `src/17-api/1710_station_now_programming_v.sql` | station current programming read model |
| `src/17-api/1720_entity_duality_view.sql` | JSON Relational Duality source/template |
| `src/18-observability/1800_tps_audit_event.sql` | project audit-event structure |
| `src/19-admin/1900_tps_schema_migration.sql` | schema migration ledger/metadata |

These areas require further source-by-source documentation/runtime certification before being called complete.

---

# 16. Reference data sources

| Path | Responsibility |
|---|---|
| `src/20-reference/2000_entity_types.sql` | entity type seed/reference |
| `src/20-reference/2010_relation_types.sql` | D3KA relation vocabulary seed/reference |
| `src/20-reference/2020_context_types.sql` | context type reference |
| `src/20-reference/2030_event_types.sql` | event type reference |
| `src/20-reference/2040_vector_types.sql` | vector type reference |
| `src/20-reference/2050_fact_classes.sql` | coverage fact-class reference |
| `src/20-reference/2060_fact_class_mappings.sql` | fact-class representation mappings |
| `src/20-reference/2070_ai_tools.sql` | canonical AI tool reference including programming tool |
| `src/20-reference/2080_content_ratings_br.sql` | Brazilian content-rating reference seed |

All reference sources are production DML if executed. Legal/regulatory reference data requires explicit business/legal review before being represented as authoritative.

---

# 17. Certification sources

| Path | Responsibility |
|---|---|
| `src/26-certification/2600_object_status.sql` | object existence/VALID state |
| `src/26-certification/2610_d3ka_cert.sql` | D3KA certification queries |
| `src/26-certification/2620_graph_cert.sql` | Property Graph certification |
| `src/26-certification/2630_vector_cert.sql` | vector certification |
| `src/26-certification/2640_knowledge_cert.sql` | knowledge/provenance certification |
| `src/26-certification/2650_ai_cert.sql` | AI metadata/authority certification |
| `src/26-certification/2660_schedule_rights_cert.sql` | schedule/rights certification |
| `src/26-certification/2690_core_summary.sql` | release summary evidence |

Certification queries are read-only evidence generators; they cannot compensate for missing behavioral tests.

---

# 18. Migration/test linkage

## V0001

Kernel/bootstrap sources. Runtime deployment remains NOT_PROVEN.

## V0002

Sources:

- AI agent-tool/guard/programming tool;
- programming package;
- continuity ledger/package;
- reference AI tool.

Tests:

- `tests/compile/COMP-001_programming_continuity.sql`
- `tests/programming/PRG-900_vertical_plsql_slice.sql`

## V0003

Sources:

- content rating;
- programming rule profile/package/trigger;
- commercial package;
- rating reference data.

Tests:

- `tests/compile/COMP-002_programming_rules_commercial.sql`
- `tests/programming/PRG-910_rules_engine.sql`
- commercial package tests when present/expanded.

---

# 19. Documentation rule per source

The embedded source header plus this catalog must together answer:

```text
WHAT
WHY
WHERE
HOW
READS
WRITES
CALLS
CALLED_BY
D3KA_LINK
AI_LINK
SECURITY
LOCKS/TRANSACTION
PERFORMANCE
FAILURE_MODES
ROLLBACK/RECOVERY
TESTS
EVIDENCE
NAME_STATUS
DEPLOYMENT_STATE
```

Any source lacking these answers remains documentation debt and cannot be considered certified.

## 20. Naming status

Unless specifically marked `USER_CANONICAL` or `APPROVED_CANONICAL` in `NAMING-AND-IDENTITY-REGISTER-v0.03.md`, object/package/file names in this catalog are `ENGINEERING_PROVISIONAL`. Their presence in Git does not mean the project owner selected the terminology.
