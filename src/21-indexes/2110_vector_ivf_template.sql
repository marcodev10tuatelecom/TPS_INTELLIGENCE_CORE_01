-- TPSDBCORE01 | CORE-08/17 | R2 | NOT DEPLOYED
-- Optional only after corpus sizing and benchmark. Neighbor partition count is intentionally not guessed.
-- Replace <N_PARTITIONS> only from benchmark decision.
CREATE VECTOR INDEX ix_tps_vector_ivf
ON tps_vector (embedding)
ORGANIZATION NEIGHBOR PARTITIONS
DISTANCE COSINE
WITH TARGET ACCURACY 95
PARAMETERS (TYPE IVF, NEIGHBOR PARTITIONS <N_PARTITIONS>)
ONLINE;
