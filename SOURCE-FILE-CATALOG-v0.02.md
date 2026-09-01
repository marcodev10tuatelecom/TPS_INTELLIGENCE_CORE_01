# TPS_INTELLIGENCE_CORE_01 — SOURCE FILE CATALOG v0.02

This catalog defines the intended source authority for TPSDBCORE01. Existing files are reconciled against this map during each gate. A listed file may be PLANNED until its content and tests are certified.

## 00 PRECHECK / CAPABILITY

| Path | Purpose | Gate | D3KA role |
|---|---|---|---|
| src/00-precheck/000_database_identity.sql | DB identity/version/charset/session proof | CORE-00 | NOT_APPLICABLE |
| src/00-precheck/010_feature_inventory.sql | feature/package/object availability | CORE-00/01 | NOT_APPLICABLE |
| src/00-precheck/020_privilege_inventory.sql | current privileges/roles | CORE-00/02 | NOT_APPLICABLE |
| src/00-precheck/030_storage_limits.sql | storage/resource baseline | CORE-00/17 | NOT_APPLICABLE |
| src/00-precheck/040_audit_baseline.sql | audit configuration baseline | CORE-00/12 | OBSERVABILITY |

All files in this section are R0 and must remain read-only.

## 01 SECURITY

| Planned path | Purpose |
|---|---|
| src/01-security/100_roles.sql | owner/runtime/API/ingest/AI/analytics/auditor/admin role model |
| src/01-security/110_object_grants.sql | least-privilege grants |
| src/01-security/120_application_context.sql | trusted application context where justified |
| src/01-security/130_audit_policies.sql | unified audit policies |
| src/01-security/140_redaction_or_vpd.sql | row/column controls if requirements demand |
| src/01-security/150_security_health_views.sql | read-only security certification views |

## 02 KERNEL — IDENTITY

| Path | Object/purpose |
|---|---|
| src/02-kernel/200_tps_entity_type.sql | controlled entity-type vocabulary |
| src/02-kernel/210_tps_entity.sql | universal globally identified entity kernel |
| src/02-kernel/220_tps_property.sql | extensible typed properties where normalized columns are not justified |
| src/02-kernel/230_tps_source.sql | evidence/import/source registry if not owned by knowledge domain |
| src/02-kernel/240_identity_alias.sql | external/canonical aliases and identity resolution |
| src/02-kernel/250_identity_merge_ledger.sql | auditable entity merge/split decisions |

## 03 D3KA — RELATION/TENSOR KERNEL

| Path | Object/purpose |
|---|---|
| src/03-d3ka/300_tps_relation_type.sql | relation vocabulary and semantic constraints |
| src/03-d3ka/310_tps_relation.sql | canonical sparse D3KA cell base: source × relation × target |
| src/03-d3ka/320_tps_d3ka_pkg.pks | public D3KA PL/SQL contract |
| src/03-d3ka/321_tps_d3ka_pkg.pkb | D3KA controlled operations |
| src/03-d3ka/330_d3ka_projection_views.sql | canonical tensor projections/slices |
| src/03-d3ka/340_d3ka_invariants.sql | invariant and contradiction checks |
| src/03-d3ka/350_tps_fact_class.sql | epistemic/fact classes |
| src/03-d3ka/351_tps_fact_class_mapping.sql | fact/relationship class mapping |
| src/03-d3ka/360_d3ka_coverage_v.sql | measurable 90% semantic coverage |
| src/03-d3ka/370_d3ka_explain_v.sql | explain coordinate, evidence, context and policy |
| src/03-d3ka/380_d3ka_conflict_v.sql | unresolved contradiction inventory |
| src/03-d3ka/390_d3ka_health_v.sql | release health indicators |

## 04 CONTEXT

| Planned path | Purpose |
|---|---|
| src/04-context/400_tps_context_type.sql | context dimension vocabulary |
| src/04-context/410_tps_context.sql | canonical context identity |
| src/04-context/420_tps_context_member.sql | context composition |
| src/04-context/430_context_precedence.sql | deterministic precedence rules |
| src/04-context/440_context_resolution_pkg.pks | context resolver contract |
| src/04-context/441_context_resolution_pkg.pkb | resolver implementation |
| src/04-context/450_context_health_v.sql | ambiguous/conflicting context detection |

## 05 TEMPORAL

| Planned path | Purpose |
|---|---|
| src/05-temporal/500_temporal_types.sql | temporal classifications |
| src/05-temporal/510_temporal_constraints.sql | valid/observed/recorded-time checks |
| src/05-temporal/520_asof_views.sql | as-of business-time projections |
| src/05-temporal/530_as_known_at_views.sql | system-knowledge-time projections |
| src/05-temporal/540_temporal_conflicts_v.sql | overlap/conflict detection |

## 06 PROPERTY GRAPH

| Path/planned | Purpose |
|---|---|
| src/06-graph/600_tps_media_knowledge_graph.sql | canonical Oracle SQL Property Graph |
| src/06-graph/610_graph_projection_views.sql | graph-safe vertex/edge projections |
| src/06-graph/620_graph_queries.sql | reusable SQL/PGQ query library |
| src/06-graph/630_graph_security_views.sql | constrained graph projections |
| src/06-graph/640_graph_health_v.sql | orphan/invalid-label/edge diagnostics |

## 07 VECTOR / SEMANTIC

| Path/planned | Purpose |
|---|---|
| src/07-vector/700_tps_vector_type.sql | vector semantic type registry |
| src/07-vector/710_tps_vector.sql | multivector registry |
| src/07-vector/720_vector_model.sql | embedding model/version metadata |
| src/07-vector/730_vector_indexes.sql | measured vector indexes only |
| src/07-vector/740_similarity_views.sql | typed similarity functions/projections |
| src/07-vector/750_vector_health_v.sql | missing/stale/dimension mismatch diagnostics |

## 08 KNOWLEDGE / PROVENANCE

| Path/planned | Purpose |
|---|---|
| src/08-knowledge/800_tps_source.sql | canonical evidence source registry |
| src/08-knowledge/810_tps_assertion.sql | facts/observations/inferences |
| src/08-knowledge/820_assertion_evidence.sql | many-to-many evidence linkage |
| src/08-knowledge/830_verification_ledger.sql | human/system verification history |
| src/08-knowledge/840_knowledge_conflict_v.sql | conflicting assertions |

## 09 EVENT FABRIC

| Planned path | Purpose |
|---|---|
| src/09-event/900_tps_event_type.sql | event vocabulary |
| src/09-event/910_tps_event.sql | append-oriented event ledger |
| src/09-event/920_event_correlation.sql | causal/correlation relationships |
| src/09-event/930_event_projection_views.sql | operational/event read models |

## 10 POLICY / RULES

| Planned path | Purpose |
|---|---|
| src/10-policy/1000_tps_policy.sql | policy definitions/lifecycle |
| src/10-policy/1010_tps_rule.sql | deterministic rules |
| src/10-policy/1020_tps_policy_engine_pkg.pks | decision contract |
| src/10-policy/1021_tps_policy_engine_pkg.pkb | evaluation engine |
| src/10-policy/1030_policy_decision_ledger.sql | rule results and reasons |
| src/10-policy/1040_policy_conflicts_v.sql | contradictory/invalid policy diagnostics |

## 11 AI / ML / RAG / AGENTS

| Planned path | Purpose |
|---|---|
| src/11-ai/1100_tps_ai_agent.sql | agent identity/configuration metadata |
| src/11-ai/1110_tps_ai_decision.sql | AI decision/audit ledger |
| src/11-ai/1120_ai_model_registry.sql | model/provider/version lifecycle |
| src/11-ai/1130_ai_tool_registry.sql | tools and authorization scope |
| src/11-ai/1140_ai_agent_tool_map.sql | allowed tool mapping |
| src/11-ai/1150_graph_rag_views.sql | graph + vector + relational retrieval projections |
| src/11-ai/1160_rag_evidence_bundle.sql | evidence bundle persistence/reference |
| src/11-ai/1170_ai_safety_health_v.sql | suspended models, failed policies, low-confidence diagnostics |
| src/11-ai/1180_select_ai_profiles.sql | Select AI profiles only after capability/security gate |
| src/11-ai/1190_ai_agent_runtime.sql | Oracle agent integration only after certification |

## 12 MEDIA / BROADCAST DOMAIN

| Planned path | Purpose |
|---|---|
| src/12-media/1200_network.sql | broadcast network domain |
| src/12-media/1210_station.sql | radio/TV station projection |
| src/12-media/1220_channel.sql | logical channels |
| src/12-media/1230_affiliate.sql | affiliate projection |
| src/12-media/1240_repeater.sql | repeater/regional projection |
| src/12-media/1250_program.sql | program metadata |
| src/12-media/1260_schedule.sql | scheduling authority |
| src/12-media/1270_schedule_item.sql | timeline slots/items |
| src/12-media/1280_media_asset.sql | asset identity/hash/location/technical metadata |
| src/12-media/1290_asset_rendition.sql | master/proxy/transcode/rendition data |
| src/12-media/1291_music_track.sql | track-specific transactional projection |
| src/12-media/1292_album.sql | album projection |
| src/12-media/1293_live_feed.sql | live-feed identity/state reference |

All domain identities map to TPS_ENTITY and relationships to D3KA.

## 13 COMMERCIAL

- 1300_advertiser.sql — advertiser projection
- 1310_campaign.sql — campaign lifecycle
- 1320_inventory.sql — commercial inventory
- 1330_placement.sql — placement/airing intent
- 1340_frequency_cap.sql — deterministic caps
- 1350_commercial_decision.sql — authorized selection result

## 14 RIGHTS

- 1400_rights_holder.sql
- 1410_right_grant.sql
- 1420_right_restriction.sql
- 1430_territory.sql
- 1440_right_window.sql
- 1450_rights_authorization_v.sql

## 15 AUDIENCE

- 1500_audience_segment.sql
- 1510_audience_observation.sql
- 1520_audience_affinity.sql
- 1530_audience_aggregate.sql
- 1540_audience_privacy_views.sql

Raw personal telemetry is not assumed to belong in this schema; privacy design controls ingestion.

## 16 EDITORIAL

- 1600_news_article.sql
- 1610_report.sql
- 1620_interview.sql
- 1630_podcast.sql
- 1640_episode.sql
- 1650_editorial_source_map.sql

## 17 API / DUALITY / READ MODELS

- 1700_station_read_model.sql
- 1710_channel_now_playing_v.sql
- 1720_program_schedule_v.sql
- 1730_entity_graph_v.sql
- 1740_json_duality_views.sql
- 1750_ords_modules.sql

API source is deployed only after runtime identity, authorization and contract tests PASS.

## 18 OBSERVABILITY

- 1800_core_health_v.sql
- 1810_d3ka_metrics_v.sql
- 1820_graph_metrics_v.sql
- 1830_vector_metrics_v.sql
- 1840_ai_metrics_v.sql
- 1850_domain_quality_v.sql

## 19 ADMIN

Controlled helpers only; no generic unrestricted DDL executor.

- 1900_release_registry.sql
- 1910_schema_version.sql
- 1920_change_ledger.sql
- 1930_data_quality_pkg.pks/.pkb

## 20 REFERENCE DATA

Controlled vocabularies and seed dictionaries, versioned and idempotent. Production business content is not embedded into schema scripts.

## 21 INDEXES

Separate files by workload class: relational, temporal, graph-supporting, text, spatial and vector. Index deployment requires measured justification and regression test.

## 22 JOBS

Scheduler jobs are disabled/not-created until explicit CORE gate approval. Every job requires idempotence, concurrency control, timeout, retry, observability and disable procedure.

## 23 EXPORT / IMPORT

Metadata/scripts for logical export, validation, import and reconciliation. No credentials or wallets committed.

## 24 MIGRATIONS

Every production schema evolution has a numbered immutable migration and a corresponding evidence/rollback or recovery decision.

## 25 ROLLBACK / RECOVERY

Contains compensating migrations or rebuild instructions. Destructive migrations may require restore/clone strategy rather than reverse SQL.

## 26 CERTIFICATION

Read-only SQL producing machine-readable gate evidence for CORE-00 through CORE-20.

## Test ownership

Every source path maps to at least one test file under `tests/`. Critical D3KA, security, policy, rights and AI-authority logic require negative tests as well as happy-path tests.

## Status semantics

PLANNED: catalog only.  
SOURCE_READY: code exists and static review complete.  
TESTED: tests passed in authorized environment.  
PRODUCTION_CHANGE_APPROVED: deployment approved.  
DEPLOYED: object/change confirmed in TPSDBCORE01.  
CERTIFIED: gate evidence complete.
