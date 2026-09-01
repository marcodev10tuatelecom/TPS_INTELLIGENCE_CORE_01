-- D3KA-004 | provenance requirement
DECLARE l_a NUMBER; l_b NUMBER; l_rt NUMBER; l_ok NUMBER:=0; l_r NUMBER;
BEGIN
 SELECT entity_id INTO l_a FROM tps_entity WHERE canonical_key='TPS_TEST_A';
 SELECT entity_id INTO l_b FROM tps_entity WHERE canonical_key='TPS_TEST_B';
 SELECT relation_type_id INTO l_rt FROM tps_relation_type WHERE relation_code='TPS_TEST_REL';
 UPDATE tps_relation_type SET requires_provenance=1,requires_context=0 WHERE relation_type_id=l_rt;
 BEGIN l_r:=tps_d3ka_pkg.assert_relation(l_a,'TPS_TEST_REL',l_b); EXCEPTION WHEN OTHERS THEN IF SQLCODE=-20005 THEN l_ok:=1; ELSE RAISE; END IF; END;
 IF l_ok<>1 THEN RAISE_APPLICATION_ERROR(-20914,'D3KA-004 FAIL'); END IF;
END;
/
