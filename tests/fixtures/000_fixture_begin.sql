-- TPSDBCORE01 TEST FIXTURE | APPROVED ISOLATED TEST SESSION ONLY
SAVEPOINT tps_test_fixture;
MERGE INTO tps_entity_type t USING (SELECT 'TPS_TEST_TYPE' code,'TPS Test Type' name FROM dual) s
ON(t.type_code=s.code) WHEN NOT MATCHED THEN INSERT(type_code,display_name) VALUES(s.code,s.name);
MERGE INTO tps_relation_type t USING (SELECT 'TPS_TEST_REL' code,'TPS Test Relation' name FROM dual) s
ON(t.relation_code=s.code) WHEN NOT MATCHED THEN INSERT(relation_code,display_name,allow_self) VALUES(s.code,s.name,0);
INSERT INTO tps_entity(entity_type_id,canonical_key,canonical_name)
SELECT entity_type_id,'TPS_TEST_A','TPS Test A' FROM tps_entity_type WHERE type_code='TPS_TEST_TYPE';
INSERT INTO tps_entity(entity_type_id,canonical_key,canonical_name)
SELECT entity_type_id,'TPS_TEST_B','TPS Test B' FROM tps_entity_type WHERE type_code='TPS_TEST_TYPE';
