-- AI-004 | Graph RAG relation evidence completeness | R0
SELECT COUNT(*) AS missing_relation_evidence
FROM (
  SELECT *
  FROM GRAPH_TABLE(
    tps_media_knowledge_graph
    MATCH (s IS entity)-[r IS relation]->(t IS entity)
    WHERE s.entity_id=:candidate_entity_id AND r.state='ACTIVE'
    COLUMNS(r.relation_id AS evidence_relation_id,
            r.provenance_source_id AS provenance_source_id,
            t.entity_id AS target_entity_id)
  )
)
WHERE evidence_relation_id IS NULL;
