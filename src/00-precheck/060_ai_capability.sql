-- TPSDBCORE01 | CORE-01 | R0 READ ONLY
SELECT owner, object_name, object_type, status
FROM all_objects
WHERE object_name IN ('DBMS_CLOUD_AI','DBMS_CLOUD_AI_AGENT')
ORDER BY owner, object_name, object_type;

SELECT owner, object_name, procedure_name
FROM all_procedures
WHERE object_name IN ('DBMS_CLOUD_AI','DBMS_CLOUD_AI_AGENT')
ORDER BY owner, object_name, procedure_name;
