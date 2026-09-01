-- D3KA-005 | duplicate active cell rejected
DECLARE l_a NUMBER; l_b NUMBER; l_rt NUMBER; l_ok NUMBER:=0;
BEGIN
 SELECT entity_id INTO l_a FROM tps_entity WHERE canonical_key='TPS_TEST_A';
 SELECT entity_id INTO l_b FROM tps_entity WHERE canonical_key='TPS_TEST_B';
 SELECT relation_type_id INTO l_rt FROM tps_relation_type WHERE relation_code='TPS_TEST_REL';
 UPDATE tps_relation_type SET requires_context=0,requires_provenance=0 WHERE relation_type_id=l_rt;
 INSERT INTO tps_relation(source_entity_id,relation_type_id,target_entity_id) VALUES(l_a,l_rt,l_b);
 BEGIN INSERT INTO tps_relation(source_entity_id,relation_type_id,target_entity_id) VALUES(l_a,l_rt,l_b); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN l_ok:=1; END;
 IF l_ok<>1 THEN RAISE_APPLICATION_ERROR(-20915,'D3KA-005 FAIL'); END IF;
END;
/
