-- PERF-004 | one-hop graph neighborhood workload | R0
SELECT * FROM tps_graph_neighbors_v
WHERE source_entity_id=:source_entity_id;
