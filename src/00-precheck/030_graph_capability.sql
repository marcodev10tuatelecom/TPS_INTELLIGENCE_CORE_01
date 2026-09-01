-- TPSDBCORE01 | CORE-01 | R0 READ ONLY
-- Dictionary discovery only; no property graph is created.
SELECT owner, object_name, object_type, status
FROM all_objects
WHERE object_type LIKE '%PROPERTY GRAPH%'
   OR object_name IN ('DBMS_GAF','DBMS_OGA')
ORDER BY owner, object_name;

SELECT COUNT(*) AS graph_dictionary_views_visible
FROM all_views
WHERE view_name LIKE '%PROPERTY_GRAPH%';
