# TPS_INTELLIGENCE_CORE_01 — Complete Source File Catalog v0.01

This catalog documents every Oracle source family currently present in the canonical repository. `R0` is read-only; `R1+` is mutating design and is **NOT authorization to execute on production**.

## 00 — Production capability prechecks

| File | Purpose | Gate | Class | Principal evidence/test |
|---|---|---:|---|---|
| `src/00-precheck/000_database_identity.sql` | Prove DB/service/user/version/charset identity before change | 00/01 | R0 | captured query output |
| `010_feature_inventory.sql` | Inventory Oracle options/packages relevant to graph/AI/spatial/text | 01 | R0 | feature matrix |
| `020_privilege_inventory.sql` | Inventory session privileges/roles/object grants | 01/02 | R0 | privilege matrix |
| `030_graph_capability.sql` | Discover Property Graph dictionary visibility without creation | 01 | R0 | graph capability matrix |
| `040_vector_capability.sql` | Discover VECTOR packages/types and run constructor-only probe | 01 | R0 | V-001 + capability |
| `050_json_duality_capability.sql` | Discover Duality objects and JSON expression support | 01 | R0 | capability matrix |
| `060_ai_capability.sql` | Discover DBMS_CLOUD_AI / DBMS_CLOUD_AI_AGENT packages/procedures | 01/10 | R0 | AI capability matrix |
| `070_audit_capability.sql` | Discover audit option/policies visibility | 01/12 | R0 | audit matrix |
| `080_capacity_snapshot.sql` | Baseline selected resource metrics/tablespace usage | 00/17 | R0 | performance baseline |

## 02 — Canonical identity kernel

| File | Purpose | Gate | Class | Dependencies / validation |
|---|---|---:|---|---|
| `src/02-kernel/200_tps_entity_type.sql` | Hierarchical canonical entity taxonomy | 03 | R1 | none; object/constraint tests |
| `210_tps_entity.sql` | Universal immutable canonical identity/lifecycle | 03 | R1 | entity type; UT-001 |
| `220_tps_property.sql` | Extensible qualified properties for entities | 03 | R1 | entity; property constraints |
| `230_tps_source.sql` | Provenance/evidence source registry | 09 | R1 | entity; provenance tests |

## 03 — D3KA tensor/relation kernel

| File | Purpose | Gate | Class | Dependencies / validation |
|---|---|---:|---|---|
| `src/03-d3ka/300_tps_relation_type.sql` | Relation taxonomy, source/target constraints and policy flags | 04 | R1 | entity types; D3KA tests |
| `310_tps_relation.sql` | Sparse D3KA cell persistence `(source,relation,target)+qualifiers` | 04 | R1 | entity/relation/context/source; UT-002, D3KA suite |
| `320_tps_d3ka_pkg.pks` | Public deterministic D3KA mutation/query contract | 04 | R1 | relation kernel |
| `321_tps_d3ka_pkg.pkb` | D3KA invariant enforcement and history-preserving end operation | 04/06/07/09 | R1 | relation kernel; D3KA-001..005 |
| `330_d3ka_projection_views.sql` | Active/history tensor read projections | 04/07 | R1 | relation kernel; slice tests |
| `340_d3ka_invariants.sql` | Diagnostic view of invariant violations | 15 | R1 object / R0 use | relation kernel; D3KA-010 |
| `350_tps_fact_class.sql` | Registry of business fact classes for 90% coverage metric | 15 | R1 | domain analysis |
| `351_tps_fact_class_mapping.sql` | Maps fact classes to D3KA/other representations | 15 | R1 | fact classes + relation types |
| `360_d3ka_coverage_v.sql` | Calculates logical D3KA coverage | 15 | R1 object / R0 use | fact mappings; D3KA-011 |

## 04 — Context engine

| File | Purpose | Gate | Class | Dependencies / validation |
|---|---|---:|---|---|
| `src/04-context/400_tps_context_type.sql` | Controlled context-dimension taxonomy | 06 | R1 | context docs |
| `410_tps_context.sql` | Dynamic/composite context instances | 06 | R1 | context type; D3KA context tests |

## 06 — Oracle Property Graph

| File | Purpose | Gate | Class | Dependencies / validation |
|---|---|---:|---|---|
| `src/06-graph/600_tps_media_knowledge_graph.sql` | Defines `TPS_MEDIA_KNOWLEDGE_GRAPH` over entity/relation SoR | 05 | R1 | CORE-01 graph capability; G tests |
| `610_tps_graph_neighbors_v.sql` | SQL/PGQ `GRAPH_TABLE` neighborhood projection | 05/15 | R1 object / R0 use | property graph; G-001..003 |

## 07 — Vector semantics

| File | Purpose | Gate | Class | Dependencies / validation |
|---|---|---:|---|---|
| `src/07-vector/700_tps_vector_type.sql` | Registry of semantic vector spaces/metrics | 08 | R1 | CORE-01 VECTOR |
| `710_tps_vector.sql` | Multi-vector store linked to entities/model/source hash | 08 | R1 | entity/vector type; V tests |
| `720_vector_similarity_queries.sql` | Exact similarity query templates/baseline | 08/17 | R0 query | vector table; V-002 |
| `src/21-indexes/2100_vector_hnsw_template.sql` | Optional HNSW ANN index design | 08/17 | R2 | measured recall/perf only |
| `2110_vector_ivf_template.sql` | Optional IVF ANN index design; partition count deliberately unresolved until benchmark | 08/17 | R2 | measured corpus/recall |

## 08 — Knowledge/provenance

| File | Purpose | Gate | Class | Dependencies / validation |
|---|---|---:|---|---|
| `src/08-knowledge/810_tps_assertion.sql` | Fact/observation/inference/AI assertion with source/confidence/verification | 09 | R1 | entity/relation type/source; AI-002, knowledge cert |

## 09 — Event fabric

| File | Purpose | Gate | Class | Dependencies / validation |
|---|---|---:|---|---|
| `src/09-event/900_tps_event_type.sql` | Canonical event taxonomy | 09/12/14 | R1 | event dictionary |
| `910_tps_event.sql` | Append-oriented business/operational event ledger | 09/12/14 | R1 | event type/entity/context/source |

## 10 — Deterministic policy engine

| File | Purpose | Gate | Class | Dependencies / validation |
|---|---|---:|---|---|
| `src/10-policy/1000_tps_policy.sql` | Policy identity, priority and validity | 11 | R1 | kernel |
| `1010_tps_rule.sql` | Versionable rule definitions subordinate to policies | 11 | R1 | policy |
| `1020_tps_policy_engine_pkg.pks` | Protected authorization interface | 11 | R1 | rights package |
| `1030_tps_policy_engine_pkg.pkb` | Fail-closed rights-aware authorization baseline | 11 | R1 | rights package; AI-003/PERF-003 |

## 11 — AI / RAG / governed agents

| File | Purpose | Gate | Class | Dependencies / validation |
|---|---|---:|---|---|
| `src/11-ai/1100_tps_ai_model.sql` | Internal governed model/provider/version registry | 10 | R1 | AI governance |
| `1110_tps_ai_agent.sql` | Governed agent identities and bounded authority classes | 10 | R1 | AI model; AI-001 |
| `1120_tps_ai_tool.sql` | Tool catalog/authority state | 10/11 | R1 | AI architecture |
| `1130_tps_ai_decision.sql` | Material AI recommendation/decision ledger | 10/12 | R1 | agent/model/context; AI cert |
| `1140_graph_rag_neighbors.sql` | Graph evidence expansion query for Graph RAG | 10/16 | R0 query | property graph; AI-004 |
| `1150_select_ai_profile_template.sql` | Controlled Select AI profile creation template | 10 | R2 | provider credential outside Git; separate change |
| `1160_agent_program_director_template.sql` | Creates governed program-director agent initially DISABLED | 10 | R2 | DBMS_CLOUD_AI_AGENT capability |
| `1170_agent_sql_tool_template.sql` | Creates read-oriented Select AI SQL tool initially DISABLED | 10 | R2 | approved profile/tool policy |
| `1180_agent_task_template.sql` | Creates advisory programming task initially DISABLED | 10 | R2 | agent/tool architecture |

## 12 — Media/programming domain

| File | Purpose | Gate | Class | Dependencies / validation |
|---|---|---:|---|---|
| `src/12-media/1200_tps_station.sql` | Station-specific projection of canonical entity | 03/14 | R1 | TPS_ENTITY |
| `1210_tps_channel.sql` | Channel operational projection | 03/14 | R1 | TPS_ENTITY |
| `1220_tps_program.sql` | Program-specific attributes over canonical identity | 03/14 | R1 | TPS_ENTITY |
| `1230_tps_schedule.sql` | Network/station/channel/local/emergency/fallback schedule authority | 14 | R1 | TPS_ENTITY |
| `1240_tps_schedule_item.sql` | Timed content/program/commercial/fallback schedule items | 14 | R1 | schedule/entity/context; schedule tests |
| `1250_tps_media_asset.sql` | Physical/digital asset metadata/hash/storage/technical state | 14 | R1 | TPS_ENTITY; asset lineage D3KA |

## 13 — Advertising/commercial

| File | Purpose | Gate | Class | Dependencies / validation |
|---|---|---:|---|---|
| `src/13-commercial/1300_tps_campaign.sql` | Campaign validity/frequency/rules metadata | 11/14 | R1 | canonical entities |
| `1310_tps_placement.sql` | Planned/authorized/played commercial placement trace | 11/14 | R1 | campaign/entity/schedule/context/event |

## 14 — Rights/licensing

| File | Purpose | Gate | Class | Dependencies / validation |
|---|---|---:|---|---|
| `src/14-rights/1400_tps_right_grant.sql` | Time/territory/context-qualified ALLOW/DENY grants | 11/14/18 | R1 | entity/context/source |
| `1410_tps_rights_pkg.pks` | Rights decision API | 11 | R1 | right grants |
| `1420_tps_rights_pkg.pkb` | DENY precedence, ALLOW, UNKNOWN semantics | 11 | R1 | right grants; PERF-003 |

## 15 — Audience

| File | Purpose | Gate | Class | Dependencies / validation |
|---|---|---:|---|---|
| `src/15-audience/1500_tps_audience_segment.sql` | Aggregate/pseudonymous/personal-restricted segment definition | 14/18 | R1 | TPS_ENTITY/privacy docs |
| `1510_tps_audience_observation.sql` | Time-series aggregate audience observations | 14/17 | R1 | segment/channel/context/source |

## 16 — Editorial

| File | Purpose | Gate | Class | Dependencies / validation |
|---|---|---:|---|---|
| `src/16-editorial/1600_tps_editorial_item.sql` | Editorial publication/correction/retraction metadata | 14 | R1 | TPS_ENTITY/TPS_SOURCE |

## 17 — API/read models

| File | Purpose | Gate | Class | Dependencies / validation |
|---|---|---:|---|---|
| `src/17-api/1700_entity_api_v.sql` | Stable entity read projection | 13 | R1 object / R0 use | entity/type |
| `1710_station_now_programming_v.sql` | Current schedule projection | 13/14 | R1 object / R0 use | schedule/items |
| `1720_entity_duality_view.sql` | JSON Relational Duality entity projection | 13 | R1 | CORE-01 Duality capability |

## 18 — Audit/observability objects

| File | Purpose | Gate | Class | Dependencies / validation |
|---|---|---:|---|---|
| `src/18-observability/1800_tps_audit_event.sql` | Business/AI/application audit event ledger complementing Oracle native audit | 12 | R1 | security/audit architecture |

## 19 — Administration/version ledger

| File | Purpose | Gate | Class | Dependencies / validation |
|---|---|---:|---|---|
| `src/19-admin/1900_tps_schema_migration.sql` | Immutable deployment/migration evidence ledger | 02/20 | R1 | governance/change control; REC-002 |

## 20 — Canonical reference taxonomies

| File | Purpose | Gate | Class | Dependencies / validation |
|---|---|---:|---|---|
| `src/20-reference/2000_entity_types.sql` | Seed/merge canonical entity types | 03/14 | R2 DML | entity type table |
| `2010_relation_types.sql` | Seed relation vocabulary including rights/policy/provenance flags | 04/14 | R2 DML | relation type table |
| `2020_context_types.sql` | Seed context dimensions | 06 | R2 DML | context type |
| `2030_event_types.sql` | Seed event vocabulary | 09/14 | R2 DML | event type |
| `2040_vector_types.sql` | Seed vector spaces | 08 | R2 DML | vector type |
| `2050_fact_classes.sql` | Seed D3KA coverage denominator with explicit eligible/noneligible rationale | 15 | R2 DML | fact class |
| `2060_fact_class_mappings.sql` | Map eligible facts to relation types/D3KA implementation | 15 | R2 DML | fact/relation taxonomies |

## 26 — Certification/read-only queries

| File | Purpose | Gate | Class |
|---|---|---:|---|
| `src/26-certification/2600_object_status.sql` | TPS object validity/inventory | 20 | R0 |
| `2610_d3ka_cert.sql` | Coverage/invariant/relation class certification | 15 | R0 |
| `2620_graph_cert.sql` | Property graph neighborhood certification | 05/15 | R0 |
| `2630_vector_cert.sql` | Vector model/type inventory and metadata checks | 08 | R0 |
| `2640_knowledge_cert.sql` | Assertion/provenance certification | 09 | R0 |
| `2650_ai_cert.sql` | Agent authority/decision inventory | 10/16 | R0 |
| `2660_schedule_rights_cert.sql` | Schedule/right data integrity summary | 11/14 | R0 |
| `2690_core_summary.sql` | CORE-20 summary input | 20 | R0 |

## Migration source

| File | Purpose | Class |
|---|---|---|
| `migrations/V0001/README.md` | Scope/status/deployment prerequisites | documentation |
| `precheck.sql` | Aggregates CORE-01 read-only prechecks | R0 |
| `apply.sql` | Ordered V0001 production mutation entry point | R3 deployment |
| `postcheck.sql` | Object/D3KA/reference post-deploy validation | R0 |
| `rollback.md` | Recovery semantics; refuses unsafe blind DROP after data exists | documentation |

## Source documentation rule

Every new `src/` file must be added to this catalog in the same change. Each row must state purpose, CORE gate, mutability class, dependencies and associated tests/evidence. A source file missing from this catalog is not eligible for production certification.
