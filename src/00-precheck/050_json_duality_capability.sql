-- TPSDBCORE01 | CORE-01 | R0 READ ONLY
SELECT owner, object_name, object_type, status
FROM all_objects
WHERE object_type LIKE '%DUALITY%'
ORDER BY owner, object_name;

SELECT JSON_OBJECT('probe' VALUE 'TPSDBCORE01') AS json_probe FROM dual;
