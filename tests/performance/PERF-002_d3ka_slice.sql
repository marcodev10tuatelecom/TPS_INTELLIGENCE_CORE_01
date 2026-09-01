-- PERF-002 | source-oriented D3KA slice | R0
SELECT relation_id,relation_type_id,target_entity_id,context_id,confidence
FROM tps_relation
WHERE source_entity_id=:source_entity_id
  AND state='ACTIVE'
  AND valid_to IS NULL;
