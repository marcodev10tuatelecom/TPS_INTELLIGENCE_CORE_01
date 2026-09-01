-- TPSDBCORE01 | CORE-12/18 | R2 GRANTS | NOT DEPLOYED
GRANT SELECT ON tps_audit_event TO tps_media_auditor;
GRANT SELECT ON tps_ai_decision TO tps_media_auditor;
GRANT SELECT ON tps_schema_migration TO tps_media_auditor;
GRANT SELECT ON tps_assertion TO tps_media_auditor;
GRANT SELECT ON tps_source TO tps_media_auditor;
