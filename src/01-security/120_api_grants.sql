-- TPSDBCORE01 | CORE-13/18 | R2 GRANTS | NOT DEPLOYED
GRANT SELECT ON tps_entity_api_v TO tps_media_api;
GRANT SELECT ON tps_station_now_programming_v TO tps_media_api;
GRANT SELECT ON tps_d3ka_active_v TO tps_media_api;
GRANT SELECT ON tps_graph_neighbors_v TO tps_media_api;
GRANT EXECUTE ON tps_schedule_pkg TO tps_media_api;
GRANT EXECUTE ON tps_policy_engine_pkg TO tps_media_api;
