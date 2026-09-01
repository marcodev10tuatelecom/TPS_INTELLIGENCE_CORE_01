-- CORE-05/15 GRAPH CERTIFICATION | R0
SELECT COUNT(*) AS graph_neighbor_rows FROM tps_graph_neighbors_v;
SELECT * FROM tps_graph_neighbors_v FETCH FIRST 20 ROWS ONLY;
