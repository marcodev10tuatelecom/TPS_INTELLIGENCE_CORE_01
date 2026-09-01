-- V0001 POSTCHECK | R0
SELECT object_type, status, COUNT(*) object_count
FROM user_objects
WHERE object_name LIKE 'TPS_%'
GROUP BY object_type,status
ORDER BY object_type,status;

SELECT * FROM tps_d3ka_coverage_v;
SELECT * FROM tps_d3ka_invariant_violations_v FETCH FIRST 100 ROWS ONLY;

SELECT COUNT(*) entity_types FROM tps_entity_type;
SELECT COUNT(*) relation_types FROM tps_relation_type;
SELECT COUNT(*) context_types FROM tps_context_type;
SELECT COUNT(*) event_types FROM tps_event_type;
SELECT COUNT(*) vector_types FROM tps_vector_type;
