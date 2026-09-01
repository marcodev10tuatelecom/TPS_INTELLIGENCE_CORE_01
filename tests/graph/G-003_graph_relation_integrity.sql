-- G-003 | every graph edge must map to one relation row | R0
SELECT COUNT(*) AS orphan_graph_edges
FROM tps_graph_neighbors_v g
LEFT JOIN tps_relation r ON r.relation_id=g.relation_id
WHERE r.relation_id IS NULL;
