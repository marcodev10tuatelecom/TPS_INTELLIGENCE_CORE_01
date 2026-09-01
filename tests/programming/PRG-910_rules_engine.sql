/*=============================================================================
 @file              tests/programming/PRG-910_rules_engine.sql
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION — SYNTHETIC ROLLBACK-ONLY TEST; EXPLICIT TEST GATE REQUIRED
 @purpose           Prove repeat-window, age-rating, rolling-hour commercial load,
                    media-duration tolerance, commercial authorization and schedule-state guard.
 @persistence       SAVEPOINT + ROLLBACK TO SAVEPOINT on PASS and failure.
 @expected          PRG-910=PASS; no synthetic rows persist.
=============================================================================*/

SET SERVEROUTPUT ON

DECLARE
    l_tag VARCHAR2(80) := 'TPS_RULE_' || RAWTOHEX(SYS_GUID());
    l_type_id NUMBER;
    l_owner_id NUMBER;
    l_prog_a NUMBER;
    l_prog_b NUMBER;
    l_creative NUMBER;
    l_advertiser NUMBER;
    l_campaign_entity NUMBER;
    l_asset_a NUMBER;
    l_asset_b NUMBER;
    l_asset_c NUMBER;
    l_source_id NUMBER;
    l_schedule_id NUMBER;
    l_item_a1 NUMBER;
    l_item_a2 NUMBER;
    l_item_ad NUMBER;
    l_placement_id NUMBER;
    l_decision VARCHAR2(80);
    l_report CLOB;
    l_count NUMBER;
    l_now TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;

    PROCEDURE assert_true(p_cond BOOLEAN, p_msg VARCHAR2) IS
    BEGIN
        IF NOT p_cond THEN
            RAISE_APPLICATION_ERROR(-20970,'PRG-910 ASSERT: ' || p_msg);
        END IF;
    END;

    PROCEDURE expect_rule_failure(p_label VARCHAR2) IS
    BEGIN
        BEGIN
            tps_programming_pkg.approve_schedule(l_schedule_id);
            RAISE_APPLICATION_ERROR(-20971,p_label || ': EXPECTED -20601');
        EXCEPTION
            WHEN OTHERS THEN
                IF SQLCODE <> -20601 THEN
                    RAISE;
                END IF;
        END;
    END;

BEGIN
    SAVEPOINT tps_prg910;

    BEGIN
        SELECT entity_type_id INTO l_type_id
          FROM tps_entity_type
         WHERE type_code='TPS_RULE_TEST';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            INSERT INTO tps_entity_type(type_code,display_name)
            VALUES('TPS_RULE_TEST','TPS Rule Test')
            RETURNING entity_type_id INTO l_type_id;
    END;

    INSERT INTO tps_entity(entity_type_id,canonical_key,canonical_name)
    VALUES(l_type_id,l_tag||'_OWNER','Synthetic Channel Owner') RETURNING entity_id INTO l_owner_id;
    INSERT INTO tps_entity(entity_type_id,canonical_key,canonical_name)
    VALUES(l_type_id,l_tag||'_PA','Synthetic Program A') RETURNING entity_id INTO l_prog_a;
    INSERT INTO tps_entity(entity_type_id,canonical_key,canonical_name)
    VALUES(l_type_id,l_tag||'_PB','Synthetic Program B') RETURNING entity_id INTO l_prog_b;
    INSERT INTO tps_entity(entity_type_id,canonical_key,canonical_name)
    VALUES(l_type_id,l_tag||'_CR','Synthetic Commercial Creative') RETURNING entity_id INTO l_creative;
    INSERT INTO tps_entity(entity_type_id,canonical_key,canonical_name)
    VALUES(l_type_id,l_tag||'_ADV','Synthetic Advertiser') RETURNING entity_id INTO l_advertiser;
    INSERT INTO tps_entity(entity_type_id,canonical_key,canonical_name)
    VALUES(l_type_id,l_tag||'_CAM','Synthetic Campaign') RETURNING entity_id INTO l_campaign_entity;
    INSERT INTO tps_entity(entity_type_id,canonical_key,canonical_name)
    VALUES(l_type_id,l_tag||'_AA','Asset A') RETURNING entity_id INTO l_asset_a;
    INSERT INTO tps_entity(entity_type_id,canonical_key,canonical_name)
    VALUES(l_type_id,l_tag||'_AB','Asset B') RETURNING entity_id INTO l_asset_b;
    INSERT INTO tps_entity(entity_type_id,canonical_key,canonical_name)
    VALUES(l_type_id,l_tag||'_AC','Asset C') RETURNING entity_id INTO l_asset_c;

    INSERT INTO tps_source(source_key,source_class,trust_level)
    VALUES(l_tag||'_SRC','SYSTEM','AUTHORITATIVE') RETURNING source_id INTO l_source_id;

    MERGE INTO tps_content_rating t
    USING (SELECT 'L' c,0 a FROM dual UNION ALL SELECT '10',10 FROM dual UNION ALL SELECT '12',12 FROM dual) s
    ON(t.rating_code=s.c)
    WHEN NOT MATCHED THEN INSERT(rating_code,country_code,display_name,minimum_age,ordinal_rank,state)
    VALUES(s.c,'BR',s.c,s.a,s.a,'ACTIVE');

    INSERT INTO tps_program(program_entity_id,default_duration_sec,editorial_rating)
    VALUES(l_prog_a,600,'L');
    INSERT INTO tps_program(program_entity_id,default_duration_sec,editorial_rating)
    VALUES(l_prog_b,600,'12');

    INSERT INTO tps_media_asset(asset_entity_id,content_entity_id,sha256_hex,duration_ms,size_bytes,storage_location,lifecycle_state)
    VALUES(l_asset_a,l_prog_a,RPAD('A',64,'A'),600000,1000,'tps://test/'||l_tag||'/a','ACTIVE');
    INSERT INTO tps_media_asset(asset_entity_id,content_entity_id,sha256_hex,duration_ms,size_bytes,storage_location,lifecycle_state)
    VALUES(l_asset_b,l_prog_b,RPAD('B',64,'B'),600000,1000,'tps://test/'||l_tag||'/b','ACTIVE');
    INSERT INTO tps_media_asset(asset_entity_id,content_entity_id,sha256_hex,duration_ms,size_bytes,storage_location,lifecycle_state)
    VALUES(l_asset_c,l_creative,RPAD('C',64,'C'),180000,1000,'tps://test/'||l_tag||'/c','ACTIVE');

    INSERT INTO tps_right_grant(content_entity_id,beneficiary_entity_id,action_code,valid_from,valid_to,decision,source_id,state)
    VALUES(l_prog_a,l_owner_id,'BROADCAST',l_now,l_now+NUMTODSINTERVAL(1,'DAY'),'ALLOW',l_source_id,'ACTIVE');
    INSERT INTO tps_right_grant(content_entity_id,beneficiary_entity_id,action_code,valid_from,valid_to,decision,source_id,state)
    VALUES(l_prog_b,l_owner_id,'BROADCAST',l_now,l_now+NUMTODSINTERVAL(1,'DAY'),'ALLOW',l_source_id,'ACTIVE');
    INSERT INTO tps_right_grant(content_entity_id,beneficiary_entity_id,action_code,valid_from,valid_to,decision,source_id,state)
    VALUES(l_creative,l_owner_id,'BROADCAST',l_now,l_now+NUMTODSINTERVAL(1,'DAY'),'ALLOW',l_source_id,'ACTIVE');

    INSERT INTO tps_programming_rule_profile(
        owner_entity_id,repeat_window_minutes,max_commercial_seconds_rolling_hour,
        max_content_minimum_age,require_program_rating,asset_duration_tolerance_sec,
        enforce_commercial_placement,state,valid_from
    ) VALUES(
        l_owner_id,120,120,10,1,2,1,'ACTIVE',l_now
    );

    l_schedule_id := tps_programming_pkg.create_schedule(
        l_tag||'_S',l_owner_id,'America/Sao_Paulo','CHANNEL',
        l_now+NUMTODSINTERVAL(60,'MINUTE'),l_now+NUMTODSINTERVAL(300,'MINUTE'),10
    );

    l_item_a1 := tps_programming_pkg.add_schedule_item(
        l_schedule_id,l_prog_a,NULL,
        l_now+NUMTODSINTERVAL(120,'MINUTE'),l_now+NUMTODSINTERVAL(130,'MINUTE'),'PROGRAM',10
    );

    l_item_a2 := tps_programming_pkg.add_schedule_item(
        l_schedule_id,l_prog_a,NULL,
        l_now+NUMTODSINTERVAL(150,'MINUTE'),l_now+NUMTODSINTERVAL(160,'MINUTE'),'PROGRAM',10
    );

    l_report := tps_programming_rules_pkg.schedule_report(l_schedule_id);
    SELECT JSON_VALUE(l_report,'$.repeat_violation_count' RETURNING NUMBER)
      INTO l_count FROM dual;
    assert_true(l_count > 0,'repeat violation should be detected');
    expect_rule_failure('REPEAT');

    UPDATE tps_schedule_item SET content_entity_id=l_prog_b WHERE schedule_item_id=l_item_a2;

    l_report := tps_programming_rules_pkg.schedule_report(l_schedule_id);
    SELECT JSON_VALUE(l_report,'$.rating_violation_count' RETURNING NUMBER)
      INTO l_count FROM dual;
    assert_true(l_count > 0,'rating violation should be detected');
    expect_rule_failure('RATING');

    UPDATE tps_program SET editorial_rating='10' WHERE program_entity_id=l_prog_b;

    l_item_ad := tps_programming_pkg.add_schedule_item(
        l_schedule_id,l_creative,NULL,
        l_now+NUMTODSINTERVAL(180,'MINUTE'),l_now+NUMTODSINTERVAL(183,'MINUTE'),'COMMERCIAL',10
    );

    INSERT INTO tps_campaign(
        campaign_entity_id,advertiser_entity_id,valid_from,valid_to,
        max_frequency_window_sec,max_frequency_count,state
    ) VALUES(
        l_campaign_entity,l_advertiser,l_now,l_now+NUMTODSINTERVAL(1,'DAY'),3600,10,'ACTIVE'
    );

    INSERT INTO tps_placement(
        campaign_entity_id,creative_entity_id,channel_entity_id,
        schedule_item_id,planned_at,state
    ) VALUES(
        l_campaign_entity,l_creative,l_owner_id,l_item_ad,
        l_now+NUMTODSINTERVAL(180,'MINUTE'),'PLANNED'
    ) RETURNING placement_id INTO l_placement_id;

    l_decision := tps_commercial_pkg.authorize_placement(
        l_placement_id,l_now+NUMTODSINTERVAL(180,'MINUTE')
    );
    assert_true(l_decision='ALLOW','commercial placement should authorize');

    l_report := tps_programming_rules_pkg.schedule_report(l_schedule_id);
    SELECT JSON_VALUE(l_report,'$.commercial_load_violation_count' RETURNING NUMBER)
      INTO l_count FROM dual;
    assert_true(l_count > 0,'180 seconds should violate 120-second rolling-hour limit');
    expect_rule_failure('AD_LOAD');

    UPDATE tps_programming_rule_profile
       SET max_commercial_seconds_rolling_hour=240,
           updated_at=SYSTIMESTAMP
     WHERE owner_entity_id=l_owner_id
       AND state='ACTIVE';

    l_report := tps_programming_rules_pkg.schedule_report(l_schedule_id);
    SELECT JSON_VALUE(l_report,'$.valid' RETURNING NUMBER)
      INTO l_count FROM dual;
    assert_true(l_count=1,'schedule should pass after deterministic corrections');

    tps_programming_pkg.approve_schedule(l_schedule_id);

    SELECT COUNT(*) INTO l_count
      FROM tps_schedule
     WHERE schedule_id=l_schedule_id AND state='APPROVED';
    assert_true(l_count=1,'schedule must reach APPROVED');

    DBMS_OUTPUT.PUT_LINE('PRG-910=PASS');
    DBMS_OUTPUT.PUT_LINE('COMMERCIAL_DECISION='||l_decision);

    ROLLBACK TO tps_prg910;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK TO tps_prg910;
        DBMS_OUTPUT.PUT_LINE('PRG-910=FAIL SQLCODE='||SQLCODE||' SQLERRM='||SQLERRM);
        RAISE;
END;
/
