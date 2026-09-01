-- V-001 | native VECTOR mathematical smoke | R0
SELECT VECTOR_DISTANCE(VECTOR('[1,0]',2,FLOAT32),VECTOR('[1,0]',2,FLOAT32),COSINE) AS same_distance,
       VECTOR_DISTANCE(VECTOR('[1,0]',2,FLOAT32),VECTOR('[0,1]',2,FLOAT32),COSINE) AS orthogonal_distance
FROM dual;
