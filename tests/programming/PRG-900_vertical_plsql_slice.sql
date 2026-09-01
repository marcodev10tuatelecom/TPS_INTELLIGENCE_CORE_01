/*=============================================================================
 @file              tests/programming/PRG-900_vertical_plsql_slice.sql
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION — SYNTHETIC ROLLBACK-ONLY TEST; EXPLICIT TEST GATE REQUIRED
 @purpose           End-to-end PL/SQL test of programming, rights, D3KA network continuity,
                    immutable decision ledger, AI capability guard and bounded AI execution.
 @persistence       SAVEPOINT + ROLLBACK TO SAVEPOINT on PASS and on failure.
 @expected          PRG-900=PASS; no synthetic rows persist.
 @warning           Performs temporary DML when executed. Inspection alone is read-only.
=============================================================================*/

SET SERVEROUTPUT ON

DECLARE
    l_tag                 VARCHAR2(80) := 'TPS_VS_' || RAWTOHEX(SYS_GUID());
    l_now                 TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
    l_type_id             NUMBER;
    l_owner_id            NUMBER;
    l_network_id          NUMBER;
    l_live_content_id     NUMBER;
    l_file_content_id     NUMBER;
    l_no_rights_id        NUMBER;
    l_asset_id            NUMBER;
    l_asset2_id           NUMBER;
    l_source_id           NUMBER;
    l_relation_type_id    NUMBER;
    l_local_schedule_id   NUMBER;
    l_network_schedule_id NUMBER;
    l_deny_schedule_id    NUMBER;
    l_ai_schedule_id      NUMBER;
    l_local_item_id       NUMBER;
    l_network_item_id     NUMBER;
    l_ai_item_id          NUMBER;
    l_current_item        NUMBER;
    l_decision_id         NUMBER;
    l_selected_item       NUMBER;
    l_decision_code       VARCHAR2(40);
    l_report              CLOB;
    l_valid               NUMBER;
    l_tool_id             NUMBER;
    l_tool_state          VARCHAR2(30);
    l_model_id            NUMBER;
    l_agent_id            NUMBER;
    l_count               NUMBER;
    l_dummy               NUMBER;

    PROCEDURE assert_true(p_condition BOOLEAN, p_message VARCHAR2) IS
    BEGIN
        IF NOT p_condition THEN
            RAISE_APPLICATION_ERROR(-20990, 'PRG-900 ASSERT: ' || p_message);
        END IF;
    END;

    FUNCTION create_entity(p_suffix VARCHAR2, p_name VARCHAR2) RETURN NUMBER IS
        l_id NUMBER;
    BEGIN
        INSERT INTO tps_entity(entity_type_id, canonical_key, canonical_name)
        VALUES(l_type_id, l_tag || '_' || p_suffix, p_name)
        RETURNING entity_id INTO l_id;
        RETURN l_id;
    END;

BEGIN
    SAVEPOINT tps_prg900;

    /* ---------- universal identity ---------- */
    BEGIN
        SELECT entity_type_id INTO l_type_id
        FROM tps_entity_type
        WHERE type_code = 'TPS_VERTICAL_TEST';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            INSERT INTO tps_entity_type(type_code, display_name, description)
            VALUES('TPS_VERTICAL_TEST','TPS Vertical Test','Rollback-only synthetic test type')
            RETURNING entity_type_id INTO l_type_id;
    END;

    l_owner_id        := create_entity('OWNER','Synthetic Affiliate Owner');
    l_network_id      := create_entity('NETWORK','Synthetic Parent Network');
    l_live_content_id := create_entity('LIVE','Synthetic Live Program');
    l_file_content_id := create_entity('FILE','Synthetic Playable File');
    l_no_rights_id    := create_entity('NO_RIGHTS','Synthetic Content Without Rights');
    l_asset_id        := create_entity('ASSET','Synthetic File Asset');
    l_asset2_id       := create_entity('ASSET2','Synthetic No-Rights Asset');

    INSERT INTO tps_source(source_key, source_class, trust_level)
    VALUES(l_tag || '_SOURCE','SYSTEM','AUTHORITATIVE')
    RETURNING source_id INTO l_source_id;

    INSERT INTO tps_media_asset(
        asset_entity_id, content_entity_id, sha256_hex, mime_type,
        codec_video, codec_audio, duration_ms, size_bytes, storage_location, lifecycle_state
    ) VALUES(
        l_asset_id, l_file_content_id, RPAD('A',64,'A'), 'video/mp4',
        'H264','AAC',1800000,1000000,'tps://synthetic/' || l_tag || '/file.mp4','ACTIVE'
    );

    INSERT INTO tps_media_asset(
        asset_entity_id, content_entity_id, sha256_hex, mime_type,
        codec_video, codec_audio, duration_ms, size_bytes, storage_location, lifecycle_state
    ) VALUES(
        l_asset2_id, l_no_rights_id, RPAD('B',64,'B'), 'video/mp4',
        'H264','AAC',1800000,1000000,'tps://synthetic/' || l_tag || '/norights.mp4','ACTIVE'
    );

    /* ---------- deterministic rights ---------- */
    INSERT INTO tps_right_grant(
        content_entity_id, beneficiary_entity_id, action_code,
        valid_from, valid_to, decision, source_id, state
    ) VALUES(
        l_live_content_id, l_owner_id, 'BROADCAST',
        l_now - INTERVAL '1' DAY, l_now + INTERVAL '2' DAY, 'ALLOW', l_source_id, 'ACTIVE'
    );

    INSERT INTO tps_right_grant(
        content_entity_id, beneficiary_entity_id, action_code,
        valid_from, valid_to, decision, source_id, state
    ) VALUES(
        l_file_content_id, l_network_id, 'BROADCAST',
        l_now - INTERVAL '1' DAY, l_now + INTERVAL '2' DAY, 'ALLOW', l_source_id, 'ACTIVE'
    );

    INSERT INTO tps_right_grant(
        content_entity_id, beneficiary_entity_id, action_code,
        valid_from, valid_to, decision, source_id, state
    ) VALUES(
        l_file_content_id, l_owner_id, 'BROADCAST',
        l_now - INTERVAL '1' DAY, l_now + INTERVAL '2' DAY, 'ALLOW', l_source_id, 'ACTIVE'
    );

    /* ---------- programming engine ---------- */
    l_local_schedule_id := tps_programming_pkg.create_schedule(
        l_tag || '_LOCAL', l_owner_id, 'America/Sao_Paulo', 'STATION',
        l_now - INTERVAL '1' HOUR, l_now + INTERVAL '2' HOUR, 10
    );

    l_local_item_id := tps_programming_pkg.add_schedule_item(
        p_schedule_id       => l_local_schedule_id,
        p_content_entity_id => l_live_content_id,
        p_start_at          => l_now - INTERVAL '10' MINUTE,
        p_end_at            => l_now + INTERVAL '20' MINUTE,
        p_item_class        => 'LIVE',
        p_priority          => 10
    );

    /* overlap must fail with the documented programming error */
    BEGIN
        l_dummy := tps_programming_pkg.add_schedule_item(
            p_schedule_id       => l_local_schedule_id,
            p_content_entity_id => l_live_content_id,
            p_start_at          => l_now,
            p_end_at            => l_now + INTERVAL '5' MINUTE,
            p_item_class        => 'LIVE'
        );
        RAISE_APPLICATION_ERROR(-20991, 'OVERLAP_WAS_NOT_REJECTED');
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE <> -20215 THEN RAISE; END IF;
    END;

    l_report := tps_programming_pkg.validation_report(l_local_schedule_id);
    SELECT JSON_VALUE(l_report, '$.valid' RETURNING NUMBER)
      INTO l_valid
      FROM dual;
    assert_true(l_valid = 1, 'LOCAL SCHEDULE SHOULD VALIDATE');

    tps_programming_pkg.approve_schedule(l_local_schedule_id);
    tps_programming_pkg.activate_schedule(l_local_schedule_id);

    l_current_item := tps_programming_pkg.current_item(l_owner_id, l_now);
    assert_true(l_current_item = l_local_item_id, 'CURRENT ITEM SHOULD BE LOCAL LIVE ITEM');

    /* asset exists but no rights grant -> must fail closed */
    l_deny_schedule_id := tps_programming_pkg.create_schedule(
        l_tag || '_DENY', l_owner_id, 'America/Sao_Paulo', 'LOCAL_OVERRIDE',
        l_now + INTERVAL '30' MINUTE, l_now + INTERVAL '90' MINUTE, 20
    );

    BEGIN
        l_dummy := tps_programming_pkg.add_schedule_item(
            p_schedule_id       => l_deny_schedule_id,
            p_content_entity_id => l_no_rights_id,
            p_start_at          => l_now + INTERVAL '40' MINUTE,
            p_end_at            => l_now + INTERVAL '50' MINUTE,
            p_item_class        => 'CONTENT'
        );
        RAISE_APPLICATION_ERROR(-20992, 'RIGHTS_FAILURE_WAS_NOT_REJECTED');
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE <> -20217 THEN RAISE; END IF;
    END;

    /* ---------- D3KA affiliation ---------- */
    BEGIN
        SELECT relation_type_id INTO l_relation_type_id
        FROM tps_relation_type
        WHERE relation_code = 'AFFILIATED_WITH';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            INSERT INTO tps_relation_type(
                relation_code, display_name, allow_self, requires_context,
                requires_provenance, policy_sensitive, lifecycle_state
            ) VALUES('AFFILIATED_WITH','Affiliated With',0,0,0,0,'ACTIVE')
            RETURNING relation_type_id INTO l_relation_type_id;
    END;

    INSERT INTO tps_relation(
        source_entity_id, relation_type_id, target_entity_id,
        provenance_source_id, confidence, assertion_class, valid_from, state
    ) VALUES(
        l_owner_id, l_relation_type_id, l_network_id,
        l_source_id, 1, 'FACT', l_now - INTERVAL '1' DAY, 'ACTIVE'
    );

    /* ---------- parent network programming ---------- */
    l_network_schedule_id := tps_programming_pkg.create_schedule(
        l_tag || '_NETWORK', l_network_id, 'America/Sao_Paulo', 'NETWORK',
        l_now - INTERVAL '1' HOUR, l_now + INTERVAL '2' HOUR, 10
    );

    l_network_item_id := tps_programming_pkg.add_schedule_item(
        p_schedule_id       => l_network_schedule_id,
        p_content_entity_id => l_file_content_id,
        p_start_at          => l_now - INTERVAL '10' MINUTE,
        p_end_at            => l_now + INTERVAL '20' MINUTE,
        p_item_class        => 'CONTENT',
        p_priority          => 10
    );

    tps_programming_pkg.approve_schedule(l_network_schedule_id);
    tps_programming_pkg.activate_schedule(l_network_schedule_id);

    /* local primary DOWN => local LIVE skipped => D3KA parent network selected */
    tps_continuity_pkg.resolve_playout(
        p_owner_entity_id => l_owner_id,
        p_primary_available => 0,
        p_at => l_now,
        o_continuity_decision_id => l_decision_id,
        o_schedule_item_id => l_selected_item,
        o_decision_code => l_decision_code
    );

    assert_true(l_selected_item = l_network_item_id, 'NETWORK ITEM SHOULD BE SELECTED');
    assert_true(l_decision_code = 'NETWORK_SCHEDULE', 'NETWORK_SCHEDULE EXPECTED');

    BEGIN
        UPDATE tps_continuity_decision
           SET decision_code = 'NO_PLAYABLE_ITEM'
         WHERE continuity_decision_id = l_decision_id;
        RAISE_APPLICATION_ERROR(-20993, 'IMMUTABLE_LEDGER_UPDATE_WAS_NOT_REJECTED');
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE <> -20301 THEN RAISE; END IF;
    END;

    /* ---------- AI capability + bounded execution ---------- */
    INSERT INTO tps_ai_model(
        model_key, provider_code, provider_model_id, model_version,
        model_class, risk_class, state
    ) VALUES(
        l_tag || '_MODEL','SYNTHETIC','SYNTHETIC_MODEL','1','LLM','LOW','ACTIVE'
    ) RETURNING ai_model_id INTO l_model_id;

    INSERT INTO tps_ai_agent(
        agent_key, display_name, ai_model_id, authority_class, state
    ) VALUES(
        l_tag || '_AGENT','Synthetic Bounded Programming Agent',
        l_model_id,'BOUNDED_AUTOMATION','ACTIVE'
    ) RETURNING ai_agent_id INTO l_agent_id;

    BEGIN
        SELECT ai_tool_id, state
          INTO l_tool_id, l_tool_state
          FROM tps_ai_tool
         WHERE tool_key = 'TPS_PROGRAMMING_TOOL';
        assert_true(l_tool_state = 'ACTIVE', 'TPS_PROGRAMMING_TOOL MUST BE ACTIVE');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            INSERT INTO tps_ai_tool(tool_key, tool_class, authority_class, state)
            VALUES('TPS_PROGRAMMING_TOOL','PLSQL_PROGRAMMING','BOUNDED_AUTOMATION','ACTIVE')
            RETURNING ai_tool_id INTO l_tool_id;
    END;

    INSERT INTO tps_ai_agent_tool(ai_agent_id, ai_tool_id, permission_mode, state)
    VALUES(l_agent_id, l_tool_id, 'READ', 'ACTIVE');
    INSERT INTO tps_ai_agent_tool(ai_agent_id, ai_tool_id, permission_mode, state)
    VALUES(l_agent_id, l_tool_id, 'PROPOSE', 'ACTIVE');
    INSERT INTO tps_ai_agent_tool(ai_agent_id, ai_tool_id, permission_mode, state)
    VALUES(l_agent_id, l_tool_id, 'EXECUTE_BOUNDED', 'ACTIVE');

    assert_true(
        tps_ai_guard_pkg.permission_allowed(
            l_agent_id,'TPS_PROGRAMMING_TOOL','EXECUTE_BOUNDED',l_now
        ) = 1,
        'BOUNDED AGENT SHOULD HAVE EXECUTE_BOUNDED'
    );

    l_ai_schedule_id := tps_programming_pkg.create_schedule(
        l_tag || '_AI_DRAFT', l_owner_id, 'America/Sao_Paulo', 'LOCAL_OVERRIDE',
        l_now + INTERVAL '2' HOUR, l_now + INTERVAL '4' HOUR, 20
    );

    /* NUMTODSINTERVAL avoids interval-literal leading-precision errors above 99 minutes. */
    l_ai_item_id := tps_ai_programming_tool_pkg.execute_bounded_add_item(
        p_ai_agent_id       => l_agent_id,
        p_schedule_id       => l_ai_schedule_id,
        p_content_entity_id => l_file_content_id,
        p_start_at          => l_now + NUMTODSINTERVAL(130,'MINUTE'),
        p_end_at            => l_now + NUMTODSINTERVAL(150,'MINUTE'),
        p_item_class        => 'CONTENT',
        p_priority          => 50,
        p_confidence        => 0.95
    );

    assert_true(l_ai_item_id IS NOT NULL, 'BOUNDED AI INSERT SHOULD RETURN ITEM ID');

    SELECT COUNT(*)
      INTO l_count
      FROM tps_ai_decision
     WHERE ai_agent_id = l_agent_id
       AND final_action = 'ADD_SCHEDULE_ITEM'
       AND policy_result = 'DETERMINISTIC_CHECKS_PASSED';
    assert_true(l_count = 1, 'BOUNDED AI SUCCESS MUST BE AUDITED');

    DBMS_OUTPUT.PUT_LINE('PRG-900=PASS');
    DBMS_OUTPUT.PUT_LINE('LOCAL_ITEM=' || l_local_item_id);
    DBMS_OUTPUT.PUT_LINE('NETWORK_FALLBACK_ITEM=' || l_network_item_id);
    DBMS_OUTPUT.PUT_LINE('AI_BOUNDED_ITEM=' || l_ai_item_id);
    DBMS_OUTPUT.PUT_LINE('CONTINUITY_DECISION=' || l_decision_code);

    ROLLBACK TO tps_prg900;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK TO tps_prg900;
        DBMS_OUTPUT.PUT_LINE('PRG-900=FAIL SQLCODE=' || SQLCODE || ' SQLERRM=' || SQLERRM);
        RAISE;
END;
/
