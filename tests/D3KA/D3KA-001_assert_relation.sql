-- D3KA-001 | valid relation assertion
DECLARE l_a NUMBER; l_b NUMBER; l_r NUMBER;
BEGIN
 SELECT entity_id INTO l_a FROM tps_entity WHERE canonical_key='TPS_TEST_A';
 SELECT entity_id INTO l_b FROM tps_entity WHERE canonical_key='TPS_TEST_B';
 l_r:=tps_d3ka_pkg.assert_relation(l_a,'TPS_TEST_REL',l_b,NULL,NULL,0.9,'FACT');
 IF l_r IS NULL THEN RAISE_APPLICATION_ERROR(-20911,'D3KA-001 FAIL'); END IF;
END;
/
