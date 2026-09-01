-- TPSDBCORE01 | CORE-10/18 | R2 GRANTS | NOT DEPLOYED
-- AI role is read-oriented; material decision writes are mediated by future controlled package/service.
GRANT SELECT ON tps_entity_api_v TO tps_media_ai;
GRANT SELECT ON tps_d3ka_active_v TO tps_media_ai;
GRANT SELECT ON tps_d3ka_history_v TO tps_media_ai;
GRANT SELECT ON tps_graph_neighbors_v TO tps_media_ai;
GRANT SELECT ON tps_vector TO tps_media_ai;
GRANT SELECT ON tps_vector_type TO tps_media_ai;
GRANT SELECT ON tps_assertion TO tps_media_ai;
GRANT SELECT ON tps_source TO tps_media_ai;
