-- V-002 | exact top-K validation baseline | R0
SELECT vector_id,entity_id,VECTOR_DISTANCE(embedding,:query_vector,COSINE) AS distance
FROM tps_vector
WHERE vector_type_id=:vector_type_id AND state='ACTIVE'
ORDER BY VECTOR_DISTANCE(embedding,:query_vector,COSINE)
FETCH FIRST 10 ROWS ONLY;
