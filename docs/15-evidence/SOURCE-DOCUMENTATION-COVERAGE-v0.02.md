# TPSDBCORE01 — SOURCE DOCUMENTATION COVERAGE v0.02

## 1. Purpose

This matrix controls the documentation retrofit of every executable database source under `src/`.

A file reaches `DOC_FULL` only when it conforms to `docs/06-data-dictionary/SOURCE-EMBEDDED-DOCUMENTATION-CONTRACT-v0.02.md`, including routine-level blocks where applicable.

## 2. Current quantitative baseline

```text
TOTAL_SOURCE_FILES = 84
DOC_FULL           = 1
DOC_PARTIAL        = 83
DOC_CERTIFIED      = 0
PRODUCTION_DEPLOYED_BY_V0.02_WORK = 0
```

The initial `DOC_PARTIAL` designation does not mean a file has no comments. It means its existing comments do not yet satisfy every required v0.02 semantic field.

## 3. Full-compliance source

| Source | Status | Reason |
|---|---|---|
| `src/00-precheck/000_database_identity.sql` | DOC_FULL | Full file contract plus statement-level purpose/impact documentation; behavior unchanged. |

## 4. Retrofit queue — precheck

| Source | Status | Target |
|---|---|---|
| `010_feature_inventory.sql` | DOC_PARTIAL | CORE-00D feature inventory documentation |
| `020_privilege_inventory.sql` | DOC_PARTIAL | privilege/security impact documentation |
| `030_graph_capability.sql` | DOC_PARTIAL | Property Graph/SQL-PGQ capability documentation |
| `040_vector_capability.sql` | DOC_PARTIAL | VECTOR capability documentation |
| `050_json_duality_capability.sql` | DOC_PARTIAL | JSON Duality capability documentation |
| `060_ai_capability.sql` | DOC_PARTIAL | Select AI/agent capability documentation |
| `070_audit_capability.sql` | DOC_PARTIAL | audit capability documentation |
| `080_capacity_snapshot.sql` | DOC_PARTIAL | capacity/performance baseline documentation |

## 5. Retrofit queue — kernel/D3KA/context/temporal

| Source | Status | Documentation emphasis |
|---|---|---|
| `src/02-kernel/200_tps_entity_type.sql` | DOC_PARTIAL | entity taxonomy authority |
| `src/02-kernel/210_tps_entity.sql` | DOC_PARTIAL | universal identity/lifecycle/temporal semantics |
| `src/02-kernel/220_tps_property.sql` | DOC_PARTIAL | extensible property semantics |
| `src/02-kernel/230_tps_source.sql` | DOC_PARTIAL | provenance/source authority |
| `src/03-d3ka/300_tps_relation_type.sql` | DOC_PARTIAL | D3KA R-axis ontology/invariants |
| `src/03-d3ka/310_tps_relation.sql` | DOC_PARTIAL | persisted D3KA cell and uniqueness |
| `src/03-d3ka/320_tps_d3ka_pkg.pks` | DOC_PARTIAL | every public routine contract |
| `src/03-d3ka/321_tps_d3ka_pkg.pkb` | DOC_PARTIAL | every public/private routine implementation impact |
| `src/03-d3ka/330_d3ka_projection_views.sql` | DOC_PARTIAL | S/R/T slicing/projection semantics |
| `src/03-d3ka/340_d3ka_invariants.sql` | DOC_PARTIAL | invalid-cell detection/invariants |
| `src/03-d3ka/350_tps_fact_class.sql` | DOC_PARTIAL | fact/observation/inference classification |
| `src/03-d3ka/351_tps_fact_class_mapping.sql` | DOC_PARTIAL | assertion mapping semantics |
| `src/03-d3ka/360_d3ka_coverage_v.sql` | DOC_PARTIAL | >=90% semantic-coverage measurement |
| `src/04-context/400_tps_context_type.sql` | DOC_PARTIAL | context taxonomy |
| `src/04-context/410_tps_context.sql` | DOC_PARTIAL | context instance/value semantics |
| `src/05-temporal/500_tps_relation_current_v.sql` | DOC_PARTIAL | current/open temporal projection |
| `src/05-temporal/510_tps_temporal_pkg.pks` | DOC_PARTIAL | routine metadata exists; full contract pending |
| `src/05-temporal/511_tps_temporal_pkg.pkb` | DOC_PARTIAL | routine metadata exists; full contract pending |

## 6. Retrofit queue — graph/vector/knowledge/event/policy

| Source | Status |
|---|---|
| `src/06-graph/600_tps_media_knowledge_graph.sql` | DOC_PARTIAL |
| `src/06-graph/610_tps_graph_neighbors_v.sql` | DOC_PARTIAL |
| `src/07-vector/700_tps_vector_type.sql` | DOC_PARTIAL |
| `src/07-vector/710_tps_vector.sql` | DOC_PARTIAL |
| `src/07-vector/720_vector_similarity_queries.sql` | DOC_PARTIAL |
| `src/08-knowledge/810_tps_assertion.sql` | DOC_PARTIAL |
| `src/09-event/900_tps_event_type.sql` | DOC_PARTIAL |
| `src/09-event/910_tps_event.sql` | DOC_PARTIAL |
| `src/10-policy/1000_tps_policy.sql` | DOC_PARTIAL |
| `src/10-policy/1010_tps_rule.sql` | DOC_PARTIAL |
| `src/10-policy/1020_tps_policy_engine_pkg.pks` | DOC_PARTIAL |
| `src/10-policy/1030_tps_policy_engine_pkg.pkb` | DOC_PARTIAL |

## 7. Retrofit queue — AI/ML/RAG/Agents

All AI sources require explicit grounding, data-exposure, authority-boundary, provenance, failure and cost/capacity documentation.

| Source | Status |
|---|---|
| `src/11-ai/1100_tps_ai_model.sql` | DOC_PARTIAL |
| `src/11-ai/1110_tps_ai_agent.sql` | DOC_PARTIAL |
| `src/11-ai/1120_tps_ai_tool.sql` | DOC_PARTIAL |
| `src/11-ai/1130_tps_ai_decision.sql` | DOC_PARTIAL |
| `src/11-ai/1140_graph_rag_neighbors.sql` | DOC_PARTIAL |
| `src/11-ai/1150_select_ai_profile_template.sql` | DOC_PARTIAL |
| `src/11-ai/1160_agent_program_director_template.sql` | DOC_PARTIAL |
| `src/11-ai/1170_agent_sql_tool_template.sql` | DOC_PARTIAL |
| `src/11-ai/1180_agent_task_template.sql` | DOC_PARTIAL |

## 8. Retrofit queue — business domains

| Source | Status |
|---|---|
| `src/12-media/1200_tps_station.sql` | DOC_PARTIAL |
| `src/12-media/1210_tps_channel.sql` | DOC_PARTIAL |
| `src/12-media/1220_tps_program.sql` | DOC_PARTIAL |
| `src/12-media/1230_tps_schedule.sql` | DOC_PARTIAL |
| `src/12-media/1240_tps_schedule_item.sql` | DOC_PARTIAL |
| `src/12-media/1250_tps_media_asset.sql` | DOC_PARTIAL |
| `src/13-commercial/1300_tps_campaign.sql` | DOC_PARTIAL |
| `src/13-commercial/1310_tps_placement.sql` | DOC_PARTIAL |
| `src/14-rights/1400_tps_right_grant.sql` | DOC_PARTIAL |
| `src/14-rights/1410_tps_rights_pkg.pks` | DOC_PARTIAL |
| `src/14-rights/1420_tps_rights_pkg.pkb` | DOC_PARTIAL |
| `src/15-audience/1500_tps_audience_segment.sql` | DOC_PARTIAL |
| `src/15-audience/1510_tps_audience_observation.sql` | DOC_PARTIAL |
| `src/16-editorial/1600_tps_editorial_item.sql` | DOC_PARTIAL |

## 9. Retrofit queue — API/operations/reference/index/certification

| Source group | Files | Status |
|---|---:|---|
| `src/17-api` | 3 | DOC_PARTIAL |
| `src/18-observability` | 1 | DOC_PARTIAL |
| `src/19-admin` | 1 | DOC_PARTIAL |
| `src/20-reference` | 7 | DOC_PARTIAL |
| `src/21-indexes` | 2 | DOC_PARTIAL |
| `src/26-certification` | 8 | DOC_PARTIAL |

## 10. Promotion rule

A source moves:

```text
DOC_PARTIAL
  -> DOC_REVIEW_REQUIRED
      -> DOC_FULL
          -> SOURCE_REVIEWED
              -> SOURCE_READY
                  -> production change gate
                      -> deployment evidence
                          -> DOC_CERTIFIED
```

No batch promotion is allowed merely because a common header was inserted. The content of every field must accurately describe the actual source behavior.
