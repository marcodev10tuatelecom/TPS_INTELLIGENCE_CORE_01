-- D3KA-002 | self relation forbidden
DECLARE l_a NUMBER; l_ok NUMBER:=0; l_r NUMBER;
BEGIN
 SELECT entity_id INTO l_a FROM tps_entity WHERE canonical_key='TPS_TEST_A';
 BEGIN l_r:=tps_d3ka_pkg.assert_relation(l_a,'TPS_TEST_REL',l_a); EXCEPTION WHEN OTHERS THEN IF SQLCODE=-20001 THEN l_ok:=1; ELSE RAISE; END IF; END;
 IF l_ok<>1 THEN RAISE_APPLICATION_ERROR(-20912,'D3KA-002 FAIL'); END IF;
END;
/
