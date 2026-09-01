-- TPSDBCORE01 | CORE-08/17 | R2 | NOT DEPLOYED
-- Optional only after recall/performance benchmark and capability approval.
CREATE VECTOR INDEX ix_tps_vector_hnsw
ON tps_vector (embedding)
ORGANIZATION INMEMORY NEIGHBOR GRAPH
DISTANCE COSINE
WITH TARGET ACCURACY 95;
