-- CORE-20 SUMMARY INPUT | R0
SELECT 'D3KA_COVERAGE' metric, TO_CHAR(d3ka_logical_coverage) value FROM tps_d3ka_coverage_v
UNION ALL
SELECT 'D3KA_INVARIANT_VIOLATIONS',TO_CHAR(COUNT(*)) FROM tps_d3ka_invariant_violations_v
UNION ALL
SELECT 'INVALID_TPS_OBJECTS',TO_CHAR(COUNT(*)) FROM user_objects WHERE object_name LIKE 'TPS_%' AND status <> 'VALID';
