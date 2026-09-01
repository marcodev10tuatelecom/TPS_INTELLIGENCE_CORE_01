-- TPSDBCORE01 | CORE-01 | R0 READ ONLY
SELECT type_name, typecode
FROM all_types
WHERE UPPER(type_name) LIKE '%VECTOR%'
ORDER BY owner, type_name;

SELECT owner, object_name, object_type, status
FROM all_objects
WHERE object_name IN ('DBMS_VECTOR','DBMS_VECTOR_CHAIN')
ORDER BY owner, object_name;

-- Constructor-only expression; does not persist data.
SELECT VECTOR('[1,2,3]', 3, FLOAT32) AS vector_probe FROM dual;
