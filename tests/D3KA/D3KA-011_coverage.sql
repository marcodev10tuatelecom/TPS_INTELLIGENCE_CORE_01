-- D3KA-011 | v0.01 target >= 90%
DECLARE l_cov NUMBER;
BEGIN
 SELECT d3ka_logical_coverage INTO l_cov FROM tps_d3ka_coverage_v;
 IF l_cov < 0.90 THEN RAISE_APPLICATION_ERROR(-20919,'D3KA COVERAGE BELOW 0.90: '||TO_CHAR(l_cov)); END IF;
END;
/
