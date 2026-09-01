-- TPSDBCORE01 | CORE-20 SUMMARY INPUT | R0
SELECT 'D3KA_IMPLEMENTED_COVERAGE' metric, TO_CHAR(implemented_coverage) value FROM tps_d3ka_coverage_v
UNION ALL
SELECT 'D3KA_VALIDATED_COVERAGE',TO_CHAR(validated_coverage) FROM tps_d3ka_coverage_v
UNION ALL
SELECT 'D3KA_CERTIFIED_COVERAGE',TO_CHAR(certified_coverage) FROM tps_d3ka_coverage_v
UNION ALL
SELECT 'D3KA_INVARIANT_VIOLATIONS',TO_CHAR(COUNT(*)) FROM tps_d3ka_invariant_violations_v
UNION ALL
SELECT 'INVALID_TPS_OBJECTS',TO_CHAR(COUNT(*)) FROM user_objects WHERE object_name LIKE 'TPS_%' AND status <> 'VALID';
