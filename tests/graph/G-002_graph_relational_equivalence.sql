-- G-002 | graph/relational edge equivalence | R0
SELECT (SELECT COUNT(*) FROM tps_graph_neighbors_v) AS graph_edges,
       (SELECT COUNT(*) FROM tps_relation WHERE state='ACTIVE') AS relational_active_edges
FROM dual;
