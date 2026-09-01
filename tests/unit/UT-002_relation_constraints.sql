-- UT-002 | invalid confidence/validity must fail
DECLARE l_a NUMBER; l_b NUMBER; l_rt NUMBER; l_ok NUMBER:=0;
BEGIN
 SELECT entity_id INTO l_a FROM tps_entity WHERE canonical_key='TPS_TEST_A';
 SELECT entity_id INTO l_b FROM tps_entity WHERE canonical_key='TPS_TEST_B';
 SELECT relation_type_id INTO l_rt FROM tps_relation_type WHERE relation_code='TPS_TEST_REL';
 BEGIN INSERT INTO tps_relation(source_entity_id,relation_type_id,target_entity_id,confidence,valid_from,valid_to)
 VALUES(l_a,l_rt,l_b,1.5,SYSTIMESTAMP,SYSTIMESTAMP-INTERVAL '1' MINUTE);
 EXCEPTION WHEN OTHERS THEN l_ok:=1; END;
 IF l_ok<>1 THEN RAISE_APPLICATION_ERROR(-20902,'UT-002 FAIL'); END IF;
END;
/
