-- FILE_ID: TEMP-500
-- TPSDBCORE01 | CORE-07 | R1 ADDITIVE | SOURCE_READY | NOT DEPLOYED
-- PURPOSE: canonical current-valid-time projection for D3KA relations.
-- D3KA_ROLE: D3KA_TEMPORAL
-- DEPENDS: TPS_RELATION
-- TESTS: tests/temporal/test_relation_current.sql
CREATE OR REPLACE VIEW tps_relation_current_v AS
SELECT r.*
  FROM tps_relation r
 WHERE r.state = 'ACTIVE'
   AND r.valid_from <= SYSTIMESTAMP
   AND (r.valid_to IS NULL OR r.valid_to > SYSTIMESTAMP);
