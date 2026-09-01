-- PERF-001 | entity lookup representative query | R0
SELECT entity_id,entity_type_id,canonical_name,state
FROM tps_entity
WHERE canonical_key=:canonical_key;
