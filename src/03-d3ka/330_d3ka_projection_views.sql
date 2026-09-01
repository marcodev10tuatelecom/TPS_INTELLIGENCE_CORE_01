-- TPSDBCORE01 | CORE-04/07 | R1 | NOT DEPLOYED
CREATE OR REPLACE VIEW tps_d3ka_active_v AS
SELECT r.relation_id,
       s.entity_id AS source_entity_id,
       s.canonical_key AS source_key,
       rt.relation_code,
       t.entity_id AS target_entity_id,
       t.canonical_key AS target_key,
       r.context_id,
       r.confidence,
       r.assertion_class,
       r.valid_from,
       r.observed_at,
       r.recorded_at
FROM tps_relation r
JOIN tps_entity s ON s.entity_id = r.source_entity_id
JOIN tps_relation_type rt ON rt.relation_type_id = r.relation_type_id
JOIN tps_entity t ON t.entity_id = r.target_entity_id
WHERE r.state = 'ACTIVE'
  AND r.valid_to IS NULL;

CREATE OR REPLACE VIEW tps_d3ka_history_v AS
SELECT r.*, rt.relation_code
FROM tps_relation r
JOIN tps_relation_type rt ON rt.relation_type_id = r.relation_type_id;
