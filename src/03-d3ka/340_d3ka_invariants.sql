-- TPSDBCORE01 | CORE-15 | R0 READ-ONLY validation view | NOT DEPLOYED
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
SELECT r.relation_id, 'INVALID_VALIDITY'
FROM tps_relation r WHERE r.valid_to IS NOT NULL AND r.valid_to <= r.valid_from;
