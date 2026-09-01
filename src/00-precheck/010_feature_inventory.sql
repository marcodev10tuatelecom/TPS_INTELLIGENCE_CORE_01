-- TPSDBCORE01 | CORE-01 | R0 READ ONLY
SELECT parameter, value
FROM v$option
WHERE UPPER(parameter) LIKE '%SPATIAL%'
   OR UPPER(parameter) LIKE '%TEXT%'
   OR UPPER(parameter) LIKE '%GRAPH%'
   OR UPPER(parameter) LIKE '%MACHINE%'
ORDER BY parameter;

SELECT owner, object_name, object_type, status
FROM all_objects
WHERE object_name IN ('DBMS_CLOUD_AI','DBMS_CLOUD_AI_AGENT','DBMS_VECTOR','DBMS_VECTOR_CHAIN','DBMS_GAF','DBMS_OGA')
ORDER BY owner, object_name, object_type;
