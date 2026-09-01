/*=============================================================================
 @file              src/20-reference/2080_content_ratings_br.sql
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @source_state      SOURCE_READY_PENDING_RUNTIME_VALIDATION
 @production_state  NOT_DEPLOYED
 @reversibility     R2_REFERENCE_DML
 @purpose           Seed machine-comparable Brazilian rating codes used by deterministic
                    programming policy. This is technical reference data, not a substitute
                    for legal/regulatory validation of each content classification.
 @objects           MERGE into TPS_CONTENT_RATING.
 @dependencies      TPS_CONTENT_RATING.
 @impact            Inserts/updates L,10,12,14,16,18 reference rows.
 @tests             tests/programming/PRG-910_rules_engine.sql.
 @owner             TPS MEDIA DATABASE ENGINEERING
=============================================================================*/

MERGE INTO tps_content_rating t
USING (
    SELECT 'L' rating_code, 'BR' country_code, 'Livre' display_name, 0 minimum_age, 0 ordinal_rank FROM dual
    UNION ALL SELECT '10','BR','10 anos',10,10 FROM dual
    UNION ALL SELECT '12','BR','12 anos',12,12 FROM dual
    UNION ALL SELECT '14','BR','14 anos',14,14 FROM dual
    UNION ALL SELECT '16','BR','16 anos',16,16 FROM dual
    UNION ALL SELECT '18','BR','18 anos',18,18 FROM dual
) s
ON (t.rating_code = s.rating_code)
WHEN MATCHED THEN UPDATE SET
    t.country_code = s.country_code,
    t.display_name = s.display_name,
    t.minimum_age = s.minimum_age,
    t.ordinal_rank = s.ordinal_rank,
    t.state = 'ACTIVE'
WHEN NOT MATCHED THEN INSERT(
    rating_code,country_code,display_name,minimum_age,ordinal_rank,state
) VALUES(
    s.rating_code,s.country_code,s.display_name,s.minimum_age,s.ordinal_rank,'ACTIVE'
);
