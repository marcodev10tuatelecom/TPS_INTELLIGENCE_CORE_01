/*=============================================================================
 @file              src/00-precheck/000_database_identity.sql
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai / Autonomous AI Transaction Processing
 @gate              CORE-00D
 @workstream        WS-03 Oracle capability engineering
 @source_state      SOURCE_READY
 @production_state  READ_ONLY_NOT_DEPLOYED
 @reversibility     READ_ONLY
 @purpose           Positively identify the connected Oracle database, session,
                    service, software version and database character sets before
                    any later production change or capability test.
 @business_impact   Prevents execution against the wrong database/service and
                    establishes immutable identity evidence for the corporate
                    media intelligence core.
 @objects           Reads DUAL, V$VERSION and NLS_DATABASE_PARAMETERS only.
 @dependencies      Connected Oracle session with dictionary access to the listed
                    read-only views.
 @upstream          OCI Autonomous Database connection/session.
 @downstream        CORE-00 evidence, CORE-01 compatibility matrix, every future
                    production change precheck.
 @d3ka_role         NONE; establishes the platform identity on which D3KA runs.
 @d3ka_links        Indirect dependency for all D3KA/graph/vector objects.
 @ai_role           NONE; identifies the database before AI capability testing.
 @security          No credentials, wallet contents or secrets are selected.
                    Output may contain service/user names and must be handled as
                    engineering evidence, not public application data.
 @performance       Constant/small dictionary reads; no table scans of business data.
 @transaction       No DML, no locks intentionally acquired, no COMMIT/ROLLBACK.
 @idempotency       Fully repeatable; repeated execution does not change state.
 @failure_modes     Missing dictionary privilege, unsupported view/column, or wrong
                    connection. Any mismatch is fail-closed for subsequent gates.
 @rollback_recovery None required because the file is read-only.
 @tests             Manual/read-only execution under CORE-00D; expected database,
                    version and charset values are compared to control-plane evidence.
 @evidence          docs/15-evidence/CORE-00/* and CORE-00D capability evidence.
 @references        Oracle AI Database 26ai Reference; Oracle SYS_CONTEXT,
                    V$VERSION and NLS_DATABASE_PARAMETERS documentation.
 @links             PROJECT-MAP.md; TRACEABILITY-MAP.md;
                    docs/03-architecture/MASTER-DATABASE-ENGINEERING-SPEC-v0.02.md;
                    docs/00-governance/DOCUMENTATION-FIRST-POLICY-v0.02.md
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.02 2026-09-01 — expanded embedded engineering documentation;
                    SQL behavior unchanged.
=============================================================================*/

-- Query 1: runtime connection identity. No persistent side effects.
SELECT SYS_CONTEXT('USERENV','DB_NAME') AS db_name,
       SYS_CONTEXT('USERENV','CURRENT_USER') AS current_user,
       SYS_CONTEXT('USERENV','CURRENT_SCHEMA') AS current_schema,
       SYS_CONTEXT('USERENV','SERVICE_NAME') AS service_name,
       SYS_CONTEXT('USERENV','SESSION_USER') AS session_user,
       SYS_CONTEXT('USERENV','INSTANCE_NAME') AS instance_name
FROM dual;

-- Query 2: exact Oracle database software banner/version for compatibility evidence.
SELECT banner_full FROM v$version;

-- Query 3: database and national character sets used by persisted text data.
SELECT parameter, value
FROM nls_database_parameters
WHERE parameter IN ('NLS_CHARACTERSET','NLS_NCHAR_CHARACTERSET')
ORDER BY parameter;
