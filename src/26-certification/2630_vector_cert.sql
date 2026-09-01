-- CORE-08 VECTOR CERTIFICATION | R0
SELECT vt.type_code, v.model_key, v.model_version, COUNT(*) vector_count
FROM tps_vector v JOIN tps_vector_type vt ON vt.vector_type_id=v.vector_type_id
GROUP BY vt.type_code,v.model_key,v.model_version
ORDER BY vt.type_code,v.model_key,v.model_version;

SELECT COUNT(*) AS invalid_dimension_metadata
FROM tps_vector
WHERE dimension_count IS NOT NULL AND dimension_count <= 0;
