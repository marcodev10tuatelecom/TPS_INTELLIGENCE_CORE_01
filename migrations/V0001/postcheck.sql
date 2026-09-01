-- V0001 POSTCHECK | READ ONLY | FAIL CLOSED
WHENEVER SQLERROR EXIT SQL.SQLCODE
SET SERVEROUTPUT ON

@@../../tests/compile/COMP-000_kernel.sql

SELECT object_type, status, COUNT(*) object_count
FROM user_objects
WHERE object_name LIKE 'TPS\_%' ESCAPE '\'
GROUP BY object_type,status
ORDER BY object_type,status;

SELECT * FROM tps_d3ka_coverage_v;
SELECT * FROM tps_d3ka_invariant_violations_v FETCH FIRST 100 ROWS ONLY;

SELECT COUNT(*) entity_types FROM tps_entity_type;
SELECT COUNT(*) relation_types FROM tps_relation_type;
SELECT COUNT(*) context_types FROM tps_context_type;
SELECT COUNT(*) event_types FROM tps_event_type;
SELECT COUNT(*) vector_types FROM tps_vector_type;

PROMPT V0001_POSTCHECK=PASS
