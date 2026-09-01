-- V0002 SECURITY APPLY | TPSDBCORE01 PRODUCTION MUTATION | APPROVAL REQUIRED
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
@@../../src/01-security/100_roles.sql
@@../../src/01-security/110_runtime_grants.sql
@@../../src/01-security/120_api_grants.sql
@@../../src/01-security/130_ingest_grants.sql
@@../../src/01-security/140_ai_grants.sql
@@../../src/01-security/150_analytics_grants.sql
@@../../src/01-security/160_auditor_grants.sql
@@../../src/01-security/170_admin_grants.sql
