-- TPSDBCORE01 | CORE-08 | R0 query templates | NOT DEPLOYED
-- Exact similarity baseline. Replace bind values only through controlled clients.
SELECT vector_id,
       entity_id,
       vector_type_id,
       VECTOR_DISTANCE(embedding, :query_vector, COSINE) AS distance
FROM tps_vector
WHERE vector_type_id = :vector_type_id
  AND state='ACTIVE'
ORDER BY VECTOR_DISTANCE(embedding, :query_vector, COSINE)
FETCH FIRST :top_k ROWS ONLY;
