-- TPSDBCORE01 | CORE-02/18 | R2 GRANTS | NOT DEPLOYED
-- Application-level administration; this is deliberately not DBA.
GRANT EXECUTE ON tps_entity_pkg TO tps_media_admin;
GRANT EXECUTE ON tps_d3ka_pkg TO tps_media_admin;
GRANT EXECUTE ON tps_event_pkg TO tps_media_admin;
GRANT EXECUTE ON tps_schedule_pkg TO tps_media_admin;
GRANT EXECUTE ON tps_rights_pkg TO tps_media_admin;
GRANT EXECUTE ON tps_policy_engine_pkg TO tps_media_admin;
GRANT SELECT ON tps_d3ka_invariant_violations_v TO tps_media_admin;
GRANT SELECT ON tps_d3ka_coverage_v TO tps_media_admin;
