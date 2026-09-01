/*=============================================================================
 @file              tests/temporal/test_relation_current.sql
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION — TEST SOURCE ONLY, NOT AUTHORIZED FOR EXECUTION BY COMMIT
 @gate              CORE-07/15
 @purpose           Validate the semantics of TPS_RELATION_CURRENT_V against the
                    underlying TPS_RELATION rows without changing persistent state.
 @dependencies      TPS_RELATION, TPS_RELATION_CURRENT_V.
 @test_type         READ_ONLY structural/semantic comparison.
 @expected          No row returned by either anti-equivalence query.
 @impact            SELECT only when executed; no DML/DDL in this test source.
 @links             src/05-temporal/500_tps_relation_current_v.sql;
                    tests/D3KA/D3KA-009_temporal.sql
=============================================================================*/

-- Any row visible in the current view must satisfy the canonical current predicate.
SELECT relation_id AS unexpected_relation_id
  FROM tps_relation_current_v
 WHERE state <> 'ACTIVE'
    OR valid_from > SYSTIMESTAMP
    OR (valid_to IS NOT NULL AND valid_to <= SYSTIMESTAMP);

-- Any base row satisfying the predicate must be represented in the current view.
SELECT r.relation_id AS missing_relation_id
  FROM tps_relation r
 WHERE r.state = 'ACTIVE'
   AND r.valid_from <= SYSTIMESTAMP
   AND (r.valid_to IS NULL OR r.valid_to > SYSTIMESTAMP)
   AND NOT EXISTS (
       SELECT 1
         FROM tps_relation_current_v v
        WHERE v.relation_id = r.relation_id
   );
