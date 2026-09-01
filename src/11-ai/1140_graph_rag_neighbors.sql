-- TPSDBCORE01 | CORE-10/16 | R0 query template | NOT DEPLOYED
-- Step 1: semantic candidate IDs are supplied by controlled retrieval.
-- Step 2: expand one-hop qualified graph context with provenance-bearing relation IDs.
SELECT *
FROM GRAPH_TABLE(
  tps_media_knowledge_graph
  MATCH (s IS entity)-[r IS relation]->(t IS entity)
  WHERE s.entity_id = :candidate_entity_id
    AND r.state = 'ACTIVE'
    AND (r.valid_to IS NULL OR r.valid_to > SYSTIMESTAMP)
  COLUMNS(
    s.entity_id AS source_entity_id,
    r.relation_id AS evidence_relation_id,
    r.relation_type_id AS relation_type_id,
    r.context_id AS context_id,
    r.confidence AS confidence,
    t.entity_id AS target_entity_id,
    t.canonical_key AS target_key
  )
);
