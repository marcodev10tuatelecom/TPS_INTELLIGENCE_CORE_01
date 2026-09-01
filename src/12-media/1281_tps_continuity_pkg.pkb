/*=============================================================================
 @file              src/12-media/1281_tps_continuity_pkg.pkb
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-05/07/11/12/14
 @workstream        24x7 continuity / affiliate-network fallback / playout resolution
 @source_state      SOURCE_READY_PENDING_RUNTIME_COMPILE_TEST
 @production_state  NOT_DEPLOYED
 @reversibility     R1_ADDITIVE body; RESOLVE_PLAYOUT writes R2 audit state
 @purpose           Implement deterministic current-time continuity resolution using local
                    schedule, emergency/fallback schedules and D3KA parent-network inheritance.
 @business_impact   Keeps a station/channel on an authorized programming path when the local
                    primary/live source disappears, without asking an LLM to improvise playout.
 @objects           Creates/replaces TPS_CONTINUITY_PKG body.
 @dependencies      TPS_PROGRAMMING_PKG, TPS_RELATION, TPS_RELATION_TYPE, TPS_ENTITY,
                    TPS_SCHEDULE, TPS_SCHEDULE_ITEM, TPS_CONTINUITY_DECISION.
 @upstream          Calls through package specification.
 @downstream        Playout item resolution and immutable decision ledger.
 @d3ka_role         RELATION/TEMPORAL/POLICY/EVENT
 @d3ka_links        Current relation traversal resolves parent network; schedule item resolution
                    applies temporal and rights/asset eligibility through programming package.
 @ai_role           NONE required for continuity safety. Future AI ranking stays subordinate.
 @security          AUTHID DEFINER, static SQL only, no arbitrary package dispatch.
 @performance       Bounded ordered candidate scans; first playable item wins deterministically.
 @transaction       One continuity-decision INSERT; no COMMIT/ROLLBACK.
 @idempotency       Each call is an auditable resolution event; caller retry-dedup is future work.
 @failure_modes     No eligible candidate returns NO_PLAYABLE_ITEM. Parent relation absence returns NULL.
                    LIVE network item technical availability is not independently proven by current schema;
                    runtime source-health integration is a future continuity enhancement.
 @rollback_recovery Caller rollback before commit; committed decisions immutable.
 @tests             tests/continuity/* and compile validation.
 @evidence          CORE-05/12/14/18.
 @references        Oracle AI Database 26ai PL/SQL/SQL references.
 @links             src/12-media/1280_tps_continuity_pkg.pks;
                    src/12-media/1261_tps_programming_pkg.pkb;
                    src/03-d3ka/310_tps_relation.sql
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.02 2026-09-01 — initial implementation.
=============================================================================*/

CREATE OR REPLACE PACKAGE BODY tps_continuity_pkg AS

  /* Private deterministic current-item selector by schedule class family. */
  FUNCTION find_item(
      p_owner_entity_id IN NUMBER,
      p_class_selector  IN VARCHAR2,
      p_at              IN TIMESTAMP WITH TIME ZONE,
      p_exclude_live    IN NUMBER DEFAULT 0
  ) RETURN NUMBER IS
  BEGIN
      FOR r IN (
          SELECT i.schedule_item_id
            FROM tps_schedule s
            JOIN tps_schedule_item i ON i.schedule_id = s.schedule_id
           WHERE s.owner_entity_id = p_owner_entity_id
             AND s.state = 'ACTIVE'
             AND s.valid_from <= p_at
             AND (s.valid_to IS NULL OR p_at < s.valid_to)
             AND i.state = 'ACTIVE'
             AND i.start_at <= p_at
             AND p_at < i.end_at
             AND (
                  (p_class_selector = 'NORMAL' AND s.schedule_class IN ('NETWORK','STATION','CHANNEL','LOCAL_OVERRIDE'))
                  OR
                  (p_class_selector <> 'NORMAL' AND s.schedule_class = p_class_selector)
             )
             AND (p_exclude_live = 0 OR i.item_class <> 'LIVE')
           ORDER BY s.precedence ASC, i.priority ASC, i.start_at DESC, i.schedule_item_id
      ) LOOP
          IF tps_programming_pkg.item_is_playable(r.schedule_item_id, p_at) = 1 THEN
              RETURN r.schedule_item_id;
          END IF;
      END LOOP;
      RETURN NULL;
  END find_item;

  FUNCTION resolve_network_entity(
      p_owner_entity_id IN NUMBER,
      p_at              IN TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP
  ) RETURN NUMBER IS
  BEGIN
      FOR r IN (
          SELECT rel.target_entity_id
            FROM tps_relation rel
            JOIN tps_relation_type rt
              ON rt.relation_type_id = rel.relation_type_id
            JOIN tps_entity target_e
              ON target_e.entity_id = rel.target_entity_id
           WHERE rel.source_entity_id = p_owner_entity_id
             AND rel.state = 'ACTIVE'
             AND rel.valid_from <= p_at
             AND (rel.valid_to IS NULL OR p_at < rel.valid_to)
             AND rt.lifecycle_state = 'ACTIVE'
             AND rt.relation_code IN ('REPEATS','AFFILIATED_WITH')
             AND target_e.state = 'ACTIVE'
           ORDER BY
             CASE rt.relation_code WHEN 'REPEATS' THEN 1 ELSE 2 END,
             rel.confidence DESC NULLS LAST,
             rel.relation_id
      ) LOOP
          RETURN r.target_entity_id;
      END LOOP;
      RETURN NULL;
  END resolve_network_entity;

  PROCEDURE resolve_playout(
      p_owner_entity_id     IN NUMBER,
      p_primary_available   IN NUMBER,
      p_at                  IN TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP,
      o_continuity_decision_id OUT NUMBER,
      o_schedule_item_id    OUT NUMBER,
      o_decision_code       OUT VARCHAR2
  ) IS
      l_dummy             NUMBER;
      l_item_id           NUMBER;
      l_item_class        VARCHAR2(30);
      l_network_entity_id NUMBER;
      l_decision_code     VARCHAR2(40);
  BEGIN
      IF p_primary_available NOT IN (0,1) THEN
          RAISE_APPLICATION_ERROR(-20310, 'TPS_CONTINUITY_PRIMARY_FLAG_MUST_BE_0_OR_1');
      END IF;

      BEGIN
          SELECT entity_id
            INTO l_dummy
            FROM tps_entity
           WHERE entity_id = p_owner_entity_id
             AND state = 'ACTIVE';
      EXCEPTION
          WHEN NO_DATA_FOUND THEN
              RAISE_APPLICATION_ERROR(-20311, 'TPS_CONTINUITY_OWNER_NOT_ACTIVE');
      END;

      /* 1. Normal local/current programming. If local primary is down, LIVE items are skipped. */
      l_item_id := find_item(
          p_owner_entity_id,
          'NORMAL',
          p_at,
          CASE WHEN p_primary_available = 0 THEN 1 ELSE 0 END
      );

      IF l_item_id IS NOT NULL THEN
          SELECT item_class
            INTO l_item_class
            FROM tps_schedule_item
           WHERE schedule_item_id = l_item_id;

          IF p_primary_available = 1 AND l_item_class = 'LIVE' THEN
              l_decision_code := 'PRIMARY';
          ELSE
              l_decision_code := 'LOCAL_SCHEDULE';
          END IF;
      END IF;

      /* 2. Local emergency schedule outranks ordinary fallback. */
      IF l_item_id IS NULL THEN
          l_item_id := find_item(p_owner_entity_id, 'EMERGENCY', p_at, 0);
          IF l_item_id IS NOT NULL THEN
              l_decision_code := 'LOCAL_EMERGENCY';
          END IF;
      END IF;

      /* 3. Local fallback schedule. */
      IF l_item_id IS NULL THEN
          l_item_id := find_item(p_owner_entity_id, 'FALLBACK', p_at, 0);
          IF l_item_id IS NOT NULL THEN
              l_decision_code := 'LOCAL_FALLBACK';
          END IF;
      END IF;

      /* 4. D3KA network inheritance: affiliate/repeater -> parent network. */
      IF l_item_id IS NULL THEN
          l_network_entity_id := resolve_network_entity(p_owner_entity_id, p_at);
          IF l_network_entity_id IS NOT NULL THEN
              l_item_id := find_item(l_network_entity_id, 'NETWORK', p_at, 0);
              IF l_item_id IS NOT NULL THEN
                  l_decision_code := 'NETWORK_SCHEDULE';
              ELSE
                  l_item_id := find_item(l_network_entity_id, 'FALLBACK', p_at, 0);
                  IF l_item_id IS NOT NULL THEN
                      l_decision_code := 'NETWORK_FALLBACK';
                  END IF;
              END IF;
          END IF;
      END IF;

      /* 5. Fail closed: do not fabricate content if no eligible programming exists. */
      IF l_item_id IS NULL THEN
          l_decision_code := 'NO_PLAYABLE_ITEM';
      END IF;

      INSERT INTO tps_continuity_decision(
          owner_entity_id,
          evaluated_at,
          primary_available,
          network_entity_id,
          selected_schedule_item_id,
          decision_code,
          reason_json
      ) VALUES (
          p_owner_entity_id,
          p_at,
          p_primary_available,
          l_network_entity_id,
          l_item_id,
          l_decision_code,
          JSON_OBJECT(
              'primary_available' VALUE p_primary_available,
              'network_entity_id' VALUE l_network_entity_id,
              'selected_schedule_item_id' VALUE l_item_id,
              'decision_code' VALUE l_decision_code
              RETURNING JSON
          )
      ) RETURNING continuity_decision_id INTO o_continuity_decision_id;

      o_schedule_item_id := l_item_id;
      o_decision_code := l_decision_code;
  END resolve_playout;

END tps_continuity_pkg;
/
