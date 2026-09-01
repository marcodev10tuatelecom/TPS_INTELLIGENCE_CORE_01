-- CORE-15 D3KA CERTIFICATION | R0
SELECT * FROM tps_d3ka_coverage_v;
SELECT COUNT(*) AS invariant_violation_count FROM tps_d3ka_invariant_violations_v;
SELECT assertion_class,state,COUNT(*)
FROM tps_relation
GROUP BY assertion_class,state
ORDER BY assertion_class,state;
