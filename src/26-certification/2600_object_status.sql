-- CORE CERTIFICATION | R0
SELECT object_type,status,COUNT(*) object_count
FROM user_objects
WHERE object_name LIKE 'TPS_%'
GROUP BY object_type,status
ORDER BY object_type,status;

SELECT object_name,object_type,status
FROM user_objects
WHERE object_name LIKE 'TPS_%' AND status <> 'VALID'
ORDER BY object_type,object_name;
