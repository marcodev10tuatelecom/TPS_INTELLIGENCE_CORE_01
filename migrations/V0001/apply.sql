-- V0001 APPLY | PRODUCTION MUTATION | DO NOT RUN WITHOUT APPROVED CHANGE
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
SET DEFINE ON VERIFY OFF
PROMPT TPSDBCORE01 V0001 - verify approved CHANGE_ID and COMMIT before proceeding.

@@../../src/19-admin/1900_tps_schema_migration.sql
@@../../src/02-kernel/200_tps_entity_type.sql
@@../../src/02-kernel/210_tps_entity.sql
@@../../src/02-kernel/220_tps_property.sql
@@../../src/02-kernel/230_tps_source.sql
@@../../src/04-context/400_tps_context_type.sql
@@../../src/04-context/410_tps_context.sql
@@../../src/03-d3ka/300_tps_relation_type.sql
@@../../src/03-d3ka/310_tps_relation.sql
@@../../src/03-d3ka/320_tps_d3ka_pkg.pks
@@../../src/03-d3ka/321_tps_d3ka_pkg.pkb
@@../../src/03-d3ka/330_d3ka_projection_views.sql
@@../../src/03-d3ka/340_d3ka_invariants.sql
@@../../src/03-d3ka/350_tps_fact_class.sql
@@../../src/03-d3ka/351_tps_fact_class_mapping.sql
@@../../src/03-d3ka/360_d3ka_coverage_v.sql
@@../../src/07-vector/700_tps_vector_type.sql
@@../../src/07-vector/710_tps_vector.sql
@@../../src/08-knowledge/810_tps_assertion.sql
@@../../src/09-event/900_tps_event_type.sql
@@../../src/09-event/910_tps_event.sql
@@../../src/10-policy/1000_tps_policy.sql
@@../../src/10-policy/1010_tps_rule.sql
@@../../src/11-ai/1100_tps_ai_model.sql
@@../../src/11-ai/1110_tps_ai_agent.sql
@@../../src/11-ai/1120_tps_ai_tool.sql
@@../../src/11-ai/1130_tps_ai_decision.sql
@@../../src/18-observability/1800_tps_audit_event.sql
@@../../src/12-media/1200_tps_station.sql
@@../../src/12-media/1210_tps_channel.sql
@@../../src/12-media/1220_tps_program.sql
@@../../src/12-media/1230_tps_schedule.sql
@@../../src/12-media/1240_tps_schedule_item.sql
@@../../src/12-media/1250_tps_media_asset.sql
@@../../src/13-commercial/1300_tps_campaign.sql
@@../../src/13-commercial/1310_tps_placement.sql
@@../../src/14-rights/1400_tps_right_grant.sql
@@../../src/14-rights/1410_tps_rights_pkg.pks
@@../../src/14-rights/1420_tps_rights_pkg.pkb
@@../../src/10-policy/1020_tps_policy_engine_pkg.pks
@@../../src/10-policy/1030_tps_policy_engine_pkg.pkb
@@../../src/15-audience/1500_tps_audience_segment.sql
@@../../src/15-audience/1510_tps_audience_observation.sql
@@../../src/16-editorial/1600_tps_editorial_item.sql
@@../../src/20-reference/2000_entity_types.sql
@@../../src/20-reference/2010_relation_types.sql
@@../../src/20-reference/2020_context_types.sql
@@../../src/20-reference/2030_event_types.sql
@@../../src/20-reference/2040_vector_types.sql
@@../../src/20-reference/2050_fact_classes.sql
@@../../src/20-reference/2060_fact_class_mappings.sql
@@../../src/06-graph/600_tps_media_knowledge_graph.sql
@@../../src/06-graph/610_tps_graph_neighbors_v.sql
@@../../src/17-api/1700_entity_api_v.sql
@@../../src/17-api/1710_station_now_programming_v.sql
-- JSON Duality and AI configuration remain separate gated subchanges.
COMMIT;
