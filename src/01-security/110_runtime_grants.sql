-- TPSDBCORE01 | CORE-02/18 | R2 GRANTS | NOT DEPLOYED
-- Runtime resolves schedule/policy and appends operational events; no direct core-table DML.
GRANT EXECUTE ON tps_schedule_pkg TO tps_media_runtime;
GRANT EXECUTE ON tps_policy_engine_pkg TO tps_media_runtime;
GRANT EXECUTE ON tps_rights_pkg TO tps_media_runtime;
GRANT EXECUTE ON tps_event_pkg TO tps_media_runtime;
GRANT SELECT ON tps_station_now_programming_v TO tps_media_runtime;
GRANT SELECT ON tps_entity_api_v TO tps_media_runtime;
