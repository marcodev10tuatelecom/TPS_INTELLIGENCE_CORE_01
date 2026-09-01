-- TPSDBCORE01 | CORE-05 | R1 VIEW | NOT DEPLOYED
CREATE OR REPLACE VIEW tps_graph_neighbors_v AS
SELECT *
FROM GRAPH_TABLE (
  tps_media_knowledge_graph
  MATCH (s IS entity)-[r IS relation]->(t IS entity)
  WHERE r.state = 'ACTIVE'
  COLUMNS (
    s.entity_id AS source_entity_id,
    s.canonical_key AS source_key,
    r.relation_id AS relation_id,
    r.relation_type_id AS relation_type_id,
    r.context_id AS context_id,
    r.confidence AS confidence,
    t.entity_id AS target_entity_id,
    t.canonical_key AS target_key
  )
);
