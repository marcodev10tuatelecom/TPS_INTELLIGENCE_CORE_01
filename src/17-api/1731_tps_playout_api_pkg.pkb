/*=============================================================================
 @file              src/17-api/1731_tps_playout_api_pkg.pkb
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-13/14/18
 @workstream        Controlled playout/read-model API
 @source_state      SOURCE_READY_PENDING_RUNTIME_COMPILE_TEST
 @production_state  NOT_DEPLOYED
 @reversibility     R1_ADDITIVE package body; continuity call writes caller-owned audit state
 @purpose           Implement JSON now/next and continuity resolution over governed PL/SQL engines.
 @business_impact   Makes programming results directly consumable by control plane/playout/API clients.
 @objects           Creates/replaces TPS_PLAYOUT_API_PKG body.
 @dependencies      TPS_PROGRAMMING_PKG, TPS_CONTINUITY_PKG, schedules/items/entities.
 @upstream          Calls through TPS_PLAYOUT_API_PKG.
 @downstream        JSON clients and continuity decision ledger.
 @d3ka_role         TEMPORAL/RELATION/API
 @d3ka_links        Returns canonical owner/content identities from D3KA-aware selection.
 @ai_role           No model call or arbitrary SQL; usable as bounded retrieval tool.
 @security          Definer-rights projection; no rights rows or secrets exposed.
 @performance       Bounded point lookups after current/next/continuity resolution.
 @transaction       NOW_NEXT read-only; RESOLVE writes one continuity decision via package; no COMMIT.
 @idempotency       NOW_NEXT deterministic for stable state/time; continuity is append-audited.
 @failure_modes     Underlying package/JSON errors propagate; absent item fields are JSON null.
 @rollback_recovery Caller rollback for continuity insert; package can be replaced/dropped.
 @tests             INT-010 and COMP-003.
 @evidence          CORE-13/14.
 @references        Oracle AI Database 26ai JSON_OBJECT documentation.
 @links             src/17-api/1730_tps_playout_api_pkg.pks
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.04 2026-09-01 — initial implementation.
=============================================================================*/

CREATE OR REPLACE PACKAGE BODY tps_playout_api_pkg AS

  PROCEDURE load_item(
      p_item_id       IN NUMBER,
      o_content_id    OUT NUMBER,
      o_content_key   OUT VARCHAR2,
      o_content_name  OUT VARCHAR2,
      o_item_class    OUT VARCHAR2,
      o_start_at      OUT TIMESTAMP WITH TIME ZONE,
      o_end_at        OUT TIMESTAMP WITH TIME ZONE,
      o_schedule_key  OUT VARCHAR2
  ) IS
  BEGIN
    o_content_id := NULL;
    o_content_key := NULL;
    o_content_name := NULL;
    o_item_class := NULL;
    o_start_at := NULL;
    o_end_at := NULL;
    o_schedule_key := NULL;

    IF p_item_id IS NULL THEN
      RETURN;
    END IF;

    SELECT si.content_entity_id,
           e.canonical_key,
           e.canonical_name,
           si.item_class,
           si.start_at,
           si.end_at,
           s.schedule_key
      INTO o_content_id,
           o_content_key,
           o_content_name,
           o_item_class,
           o_start_at,
           o_end_at,
           o_schedule_key
      FROM tps_schedule_item si
      JOIN tps_schedule s ON s.schedule_id=si.schedule_id
      JOIN tps_entity e ON e.entity_id=si.content_entity_id
     WHERE si.schedule_item_id=p_item_id;
  END load_item;

  FUNCTION now_next_json(
      p_owner_entity_id IN NUMBER,
      p_at              IN TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP
  ) RETURN CLOB IS
    l_now_id NUMBER;
    l_next_id NUMBER;
    l_now_content_id NUMBER;
    l_now_key VARCHAR2(300);
    l_now_name VARCHAR2(500);
    l_now_class VARCHAR2(30);
    l_now_start TIMESTAMP WITH TIME ZONE;
    l_now_end TIMESTAMP WITH TIME ZONE;
    l_now_schedule VARCHAR2(300);
    l_next_content_id NUMBER;
    l_next_key VARCHAR2(300);
    l_next_name VARCHAR2(500);
    l_next_class VARCHAR2(30);
    l_next_start TIMESTAMP WITH TIME ZONE;
    l_next_end TIMESTAMP WITH TIME ZONE;
    l_next_schedule VARCHAR2(300);
    l_json CLOB;
  BEGIN
    l_now_id := tps_programming_pkg.current_item(p_owner_entity_id,p_at);
    l_next_id := tps_programming_pkg.next_item(p_owner_entity_id,p_at);

    load_item(l_now_id,l_now_content_id,l_now_key,l_now_name,l_now_class,l_now_start,l_now_end,l_now_schedule);
    load_item(l_next_id,l_next_content_id,l_next_key,l_next_name,l_next_class,l_next_start,l_next_end,l_next_schedule);

    SELECT JSON_OBJECT(
             'owner_entity_id' VALUE p_owner_entity_id,
             'evaluated_at' VALUE TO_CHAR(p_at,'YYYY-MM-DD"T"HH24:MI:SS.FF3TZH:TZM'),
             'now_item_id' VALUE l_now_id,
             'now_schedule_key' VALUE l_now_schedule,
             'now_content_entity_id' VALUE l_now_content_id,
             'now_content_key' VALUE l_now_key,
             'now_content_name' VALUE l_now_name,
             'now_item_class' VALUE l_now_class,
             'now_start_at' VALUE CASE WHEN l_now_start IS NULL THEN NULL ELSE TO_CHAR(l_now_start,'YYYY-MM-DD"T"HH24:MI:SS.FF3TZH:TZM') END,
             'now_end_at' VALUE CASE WHEN l_now_end IS NULL THEN NULL ELSE TO_CHAR(l_now_end,'YYYY-MM-DD"T"HH24:MI:SS.FF3TZH:TZM') END,
             'next_item_id' VALUE l_next_id,
             'next_schedule_key' VALUE l_next_schedule,
             'next_content_entity_id' VALUE l_next_content_id,
             'next_content_key' VALUE l_next_key,
             'next_content_name' VALUE l_next_name,
             'next_item_class' VALUE l_next_class,
             'next_start_at' VALUE CASE WHEN l_next_start IS NULL THEN NULL ELSE TO_CHAR(l_next_start,'YYYY-MM-DD"T"HH24:MI:SS.FF3TZH:TZM') END,
             'next_end_at' VALUE CASE WHEN l_next_end IS NULL THEN NULL ELSE TO_CHAR(l_next_end,'YYYY-MM-DD"T"HH24:MI:SS.FF3TZH:TZM') END
             RETURNING CLOB
           ) INTO l_json
      FROM dual;
    RETURN l_json;
  END now_next_json;

  FUNCTION resolve_playout_json(
      p_owner_entity_id   IN NUMBER,
      p_primary_available IN NUMBER,
      p_at                IN TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP
  ) RETURN CLOB IS
    l_decision_id NUMBER;
    l_item_id NUMBER;
    l_decision_code VARCHAR2(40);
    l_content_id NUMBER;
    l_content_key VARCHAR2(300);
    l_content_name VARCHAR2(500);
    l_item_class VARCHAR2(30);
    l_start_at TIMESTAMP WITH TIME ZONE;
    l_end_at TIMESTAMP WITH TIME ZONE;
    l_schedule_key VARCHAR2(300);
    l_json CLOB;
  BEGIN
    tps_continuity_pkg.resolve_playout(
      p_owner_entity_id => p_owner_entity_id,
      p_primary_available => p_primary_available,
      p_at => p_at,
      o_continuity_decision_id => l_decision_id,
      o_schedule_item_id => l_item_id,
      o_decision_code => l_decision_code
    );

    load_item(l_item_id,l_content_id,l_content_key,l_content_name,l_item_class,l_start_at,l_end_at,l_schedule_key);

    SELECT JSON_OBJECT(
             'owner_entity_id' VALUE p_owner_entity_id,
             'evaluated_at' VALUE TO_CHAR(p_at,'YYYY-MM-DD"T"HH24:MI:SS.FF3TZH:TZM'),
             'primary_available' VALUE p_primary_available,
             'continuity_decision_id' VALUE l_decision_id,
             'decision_code' VALUE l_decision_code,
             'schedule_item_id' VALUE l_item_id,
             'schedule_key' VALUE l_schedule_key,
             'content_entity_id' VALUE l_content_id,
             'content_key' VALUE l_content_key,
             'content_name' VALUE l_content_name,
             'item_class' VALUE l_item_class,
             'start_at' VALUE CASE WHEN l_start_at IS NULL THEN NULL ELSE TO_CHAR(l_start_at,'YYYY-MM-DD"T"HH24:MI:SS.FF3TZH:TZM') END,
             'end_at' VALUE CASE WHEN l_end_at IS NULL THEN NULL ELSE TO_CHAR(l_end_at,'YYYY-MM-DD"T"HH24:MI:SS.FF3TZH:TZM') END
             RETURNING CLOB
           ) INTO l_json
      FROM dual;
    RETURN l_json;
  END resolve_playout_json;

END tps_playout_api_pkg;
/
