-- TPSDBCORE01 | CORE-02/18 | R2 GRANTS | NOT DEPLOYED
-- Ingest writes through invariant-enforcing packages, not direct core DML.
GRANT EXECUTE ON tps_entity_pkg TO tps_media_ingest;
GRANT EXECUTE ON tps_d3ka_pkg TO tps_media_ingest;
GRANT EXECUTE ON tps_event_pkg TO tps_media_ingest;
GRANT SELECT ON tps_entity_api_v TO tps_media_ingest;
