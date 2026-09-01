-- D3KA-011 | CORE-15 requires validated coverage >= 90%; CORE-20 may require certified coverage by release policy.
DECLARE l_cov NUMBER;
BEGIN
 SELECT validated_coverage INTO l_cov FROM tps_d3ka_coverage_v;
 IF l_cov < 0.90 THEN
   RAISE_APPLICATION_ERROR(-20919,'D3KA VALIDATED COVERAGE BELOW 0.90: '||TO_CHAR(l_cov));
 END IF;
END;
/
