-- TPSDBCORE01 | CORE-15 | R1 VIEW / R0 USE | NOT DEPLOYED
CREATE OR REPLACE VIEW tps_d3ka_invariant_violations_v AS
SELECT r.relation_id, 'SELF_RELATION_NOT_ALLOWED' AS violation
FROM tps_relation r JOIN tps_relation_type rt ON rt.relation_type_id=r.relation_type_id
WHERE rt.allow_self=0 AND r.source_entity_id=r.target_entity_id
UNION ALL
SELECT r.relation_id, 'CONTEXT_REQUIRED'
FROM tps_relation r JOIN tps_relation_type rt ON rt.relation_type_id=r.relation_type_id
WHERE rt.requires_context=1 AND r.context_id IS NULL
UNION ALL
SELECT r.relation_id, 'PROVENANCE_REQUIRED'
FROM tps_relation r JOIN tps_relation_type rt ON rt.relation_type_id=r.relation_type_id
WHERE rt.requires_provenance=1 AND r.provenance_source_id IS NULL
UNION ALL
SELECT r.relation_id, 'ASSERTION_CLASS_PROVENANCE_REQUIRED'
FROM tps_relation r
WHERE r.assertion_class IN ('INFERENCE','AI_INFERENCE','EXTERNAL_IMPORT')
  AND r.provenance_source_id IS NULL
UNION ALL
SELECT r.relation_id, 'INVALID_VALIDITY'
FROM tps_relation r WHERE r.valid_to IS NOT NULL AND r.valid_to <= r.valid_from
UNION ALL
SELECT r.relation_id, 'INVALID_SOURCE_TYPE'
FROM tps_relation r
JOIN tps_relation_type rt ON rt.relation_type_id=r.relation_type_id
JOIN tps_entity s ON s.entity_id=r.source_entity_id
WHERE rt.source_entity_type_id IS NOT NULL AND rt.source_entity_type_id<>s.entity_type_id
UNION ALL
SELECT r.relation_id, 'INVALID_TARGET_TYPE'
FROM tps_relation r
JOIN tps_relation_type rt ON rt.relation_type_id=r.relation_type_id
JOIN tps_entity t ON t.entity_id=r.target_entity_id
WHERE rt.target_entity_type_id IS NOT NULL AND rt.target_entity_type_id<>t.entity_type_id;
