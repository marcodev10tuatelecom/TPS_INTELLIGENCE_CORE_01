-- INT-010 — End-to-end broadcast core integration
-- Requires V0001 + V0002 + V0003 + V0004 compiled.
-- Creates only synthetic rows after SAVEPOINT and rolls them back.
SET SERVEROUTPUT ON
DECLARE
  l_at              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  l_run             VARCHAR2(40) := TO_CHAR(SYSTIMESTAMP,'YYYYMMDDHH24MISSFF3');
  l_prefix          VARCHAR2(100);
  l_network_id      NUMBER;
  l_station_id      NUMBER;
  l_channel_id      NUMBER;
  l_program_id      NUMBER;
  l_asset_id        NUMBER;
  l_relation_id     NUMBER;
  l_source_entity   NUMBER;
  l_source_id       NUMBER;
  l_right_id        NUMBER;
  l_schedule_id     NUMBER;
  l_item_id         NUMBER;
  l_now_json        CLOB;
  l_playout_json    CLOB;
  l_hash            VARCHAR2(64);
  l_value           VARCHAR2(4000);
BEGIN
  SAVEPOINT int010_start;
  l_prefix := 'INT010:'||l_run||':';

  l_network_id := tps_broadcast_admin_pkg.register_network(
      l_prefix||'NETWORK','INT-010 Synthetic Network');

  l_station_id := tps_broadcast_admin_pkg.register_station(
      l_prefix||'STATION','INT-010 Synthetic TV Affiliate','TV','America/Sao_Paulo','BRA');

  l_channel_id := tps_broadcast_admin_pkg.register_channel(
      l_prefix||'CHANNEL','INT-010 Synthetic Channel','TV',l_prefix||'SERVICE','America/Sao_Paulo');

  l_program_id := tps_broadcast_admin_pkg.register_program(
      l_prefix||'PROGRAM','INT-010 Synthetic Program','ANIMATION',1800,NULL);

  IF l_network_id IS NULL OR l_station_id IS NULL OR l_channel_id IS NULL OR l_program_id IS NULL THEN
    RAISE_APPLICATION_ERROR(-20940,'INT-010 entity registration failed');
  END IF;

  l_relation_id := tps_broadcast_admin_pkg.affiliate_station(l_station_id,l_network_id,l_at-INTERVAL '1' HOUR);
  IF l_relation_id IS NULL THEN
    RAISE_APPLICATION_ERROR(-20941,'INT-010 affiliation relation failed');
  END IF;

  l_source_entity := tps_broadcast_admin_pkg.ensure_entity(
      'SYSTEM',l_prefix||'RIGHTS-SOURCE','INT-010 Synthetic Rights Source');

  MERGE INTO tps_source s
  USING (SELECT l_prefix||'SOURCE' source_key, l_source_entity source_entity_id FROM dual) x
     ON (s.source_key=x.source_key)
  WHEN MATCHED THEN UPDATE SET s.source_entity_id=x.source_entity_id, s.trust_level='AUTHORITATIVE'
  WHEN NOT MATCHED THEN INSERT(source_key,source_class,source_entity_id,trust_level)
       VALUES(x.source_key,'SYSTEM',x.source_entity_id,'AUTHORITATIVE');

  SELECT source_id INTO l_source_id FROM tps_source WHERE source_key=l_prefix||'SOURCE';

  SELECT LOWER(RAWTOHEX(STANDARD_HASH(l_prefix||'ASSET','SHA256'))) INTO l_hash FROM dual;
  l_asset_id := tps_broadcast_admin_pkg.register_media_asset(
      p_asset_key => l_prefix||'ASSET-ENTITY',
      p_asset_name => 'INT-010 Synthetic Master Asset',
      p_content_entity_id => l_program_id,
      p_sha256_hex => l_hash,
      p_storage_location => '/synthetic/'||l_run||'/program.mp4',
      p_duration_ms => 1800000,
      p_mime_type => 'video/mp4',
      p_codec_video => 'H264',
      p_codec_audio => 'AAC');

  IF l_asset_id IS NULL THEN
    RAISE_APPLICATION_ERROR(-20942,'INT-010 media asset registration failed');
  END IF;

  l_right_id := tps_rights_admin_pkg.grant_right(
      p_content_entity_id => l_program_id,
      p_beneficiary_entity_id => l_network_id,
      p_action_code => 'BROADCAST',
      p_valid_from => l_at-INTERVAL '1' HOUR,
      p_valid_to => l_at+INTERVAL '2' HOUR,
      p_decision => 'ALLOW',
      p_source_id => l_source_id);

  IF l_right_id IS NULL THEN
    RAISE_APPLICATION_ERROR(-20943,'INT-010 rights grant failed');
  END IF;

  INSERT INTO tps_programming_rule_profile(
      owner_entity_id,repeat_window_minutes,max_commercial_seconds_rolling_hour,
      max_content_minimum_age,require_program_rating,asset_duration_tolerance_sec,
      enforce_commercial_placement,state,valid_from,valid_to
  ) VALUES(
      l_network_id,0,3600,18,0,5,0,'ACTIVE',l_at-INTERVAL '1' HOUR,l_at+INTERVAL '2' HOUR
  );

  l_schedule_id := tps_programming_pkg.create_schedule(
      p_schedule_key => l_prefix||'NETWORK-SCHEDULE',
      p_owner_entity_id => l_network_id,
      p_timezone_name => 'America/Sao_Paulo',
      p_schedule_class => 'NETWORK',
      p_valid_from => l_at-INTERVAL '10' MINUTE,
      p_valid_to => l_at+INTERVAL '2' HOUR,
      p_precedence => 10);

  l_item_id := tps_programming_pkg.add_schedule_item(
      p_schedule_id => l_schedule_id,
      p_content_entity_id => l_program_id,
      p_start_at => l_at-INTERVAL '5' MINUTE,
      p_end_at => l_at+INTERVAL '25' MINUTE,
      p_item_class => 'PROGRAM',
      p_priority => 10);

  tps_programming_pkg.approve_schedule(l_schedule_id);
  tps_programming_pkg.activate_schedule(l_schedule_id);

  l_now_json := tps_playout_api_pkg.now_next_json(l_network_id,l_at);
  SELECT JSON_VALUE(l_now_json,'$.now_item_id' RETURNING VARCHAR2)
    INTO l_value FROM dual;
  IF l_value IS NULL OR TO_NUMBER(l_value) <> l_item_id THEN
    RAISE_APPLICATION_ERROR(-20944,'INT-010 now/next did not return active network item');
  END IF;

  l_playout_json := tps_playout_api_pkg.resolve_playout_json(l_station_id,0,l_at);
  SELECT JSON_VALUE(l_playout_json,'$.decision_code' RETURNING VARCHAR2)
    INTO l_value FROM dual;
  IF l_value <> 'NETWORK_SCHEDULE' THEN
    RAISE_APPLICATION_ERROR(-20945,'INT-010 expected NETWORK_SCHEDULE, got '||NVL(l_value,'NULL'));
  END IF;

  SELECT JSON_VALUE(l_playout_json,'$.schedule_item_id' RETURNING VARCHAR2)
    INTO l_value FROM dual;
  IF l_value IS NULL OR TO_NUMBER(l_value) <> l_item_id THEN
    RAISE_APPLICATION_ERROR(-20946,'INT-010 continuity selected wrong item');
  END IF;

  DBMS_OUTPUT.PUT_LINE('INT010_NETWORK_ID='||l_network_id);
  DBMS_OUTPUT.PUT_LINE('INT010_STATION_ID='||l_station_id);
  DBMS_OUTPUT.PUT_LINE('INT010_CHANNEL_ID='||l_channel_id);
  DBMS_OUTPUT.PUT_LINE('INT010_PROGRAM_ID='||l_program_id);
  DBMS_OUTPUT.PUT_LINE('INT010_ASSET_ID='||l_asset_id);
  DBMS_OUTPUT.PUT_LINE('INT010_RELATION_ID='||l_relation_id);
  DBMS_OUTPUT.PUT_LINE('INT010_RIGHT_ID='||l_right_id);
  DBMS_OUTPUT.PUT_LINE('INT010_SCHEDULE_ID='||l_schedule_id);
  DBMS_OUTPUT.PUT_LINE('INT010_ITEM_ID='||l_item_id);
  DBMS_OUTPUT.PUT_LINE('INT010_NOW_NEXT='||DBMS_LOB.SUBSTR(l_now_json,3000,1));
  DBMS_OUTPUT.PUT_LINE('INT010_PLAYOUT='||DBMS_LOB.SUBSTR(l_playout_json,3000,1));
  DBMS_OUTPUT.PUT_LINE('INT-010=PASS');

  ROLLBACK TO int010_start;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK TO int010_start;
    DBMS_OUTPUT.PUT_LINE('INT-010=FAIL');
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
    RAISE;
END;
/
