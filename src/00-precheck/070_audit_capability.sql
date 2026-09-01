-- TPSDBCORE01 | CORE-01/12 | R0 READ ONLY
SELECT parameter, value
FROM v$option
WHERE UPPER(parameter) LIKE '%AUDIT%'
ORDER BY parameter;

SELECT COUNT(*) AS unified_audit_policies_visible
FROM audit_unified_policies;
