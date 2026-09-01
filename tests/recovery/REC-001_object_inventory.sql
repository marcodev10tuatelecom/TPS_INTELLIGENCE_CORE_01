-- REC-001 | compare object inventory before/after rebuild | R0
SELECT object_type,object_name,status
FROM user_objects
WHERE object_name LIKE 'TPS_%'
ORDER BY object_type,object_name;
