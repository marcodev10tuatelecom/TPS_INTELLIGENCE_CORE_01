-- TPSDBCORE01 | CORE-00D | R0 READ ONLY
-- Purpose: positively identify the connected database/session before any future change.
SELECT SYS_CONTEXT('USERENV','DB_NAME') AS db_name,
       SYS_CONTEXT('USERENV','CURRENT_USER') AS current_user,
       SYS_CONTEXT('USERENV','CURRENT_SCHEMA') AS current_schema,
       SYS_CONTEXT('USERENV','SERVICE_NAME') AS service_name,
       SYS_CONTEXT('USERENV','SESSION_USER') AS session_user,
       SYS_CONTEXT('USERENV','INSTANCE_NAME') AS instance_name
FROM dual;

SELECT banner_full FROM v$version;

SELECT parameter, value
FROM nls_database_parameters
WHERE parameter IN ('NLS_CHARACTERSET','NLS_NCHAR_CHARACTERSET')
ORDER BY parameter;
