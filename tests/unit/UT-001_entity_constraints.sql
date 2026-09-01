-- UT-001 | entity canonical key uniqueness
DECLARE l_type NUMBER; l_ok NUMBER:=0;
BEGIN
 SELECT entity_type_id INTO l_type FROM tps_entity_type WHERE type_code='TPS_TEST_TYPE';
 BEGIN INSERT INTO tps_entity(entity_type_id,canonical_key,canonical_name) VALUES(l_type,'TPS_TEST_A','Duplicate');
 EXCEPTION WHEN DUP_VAL_ON_INDEX THEN l_ok:=1; END;
 IF l_ok<>1 THEN RAISE_APPLICATION_ERROR(-20901,'UT-001 FAIL'); END IF;
END;
/
