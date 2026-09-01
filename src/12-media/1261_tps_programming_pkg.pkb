/*=============================================================================
 @file              src/12-media/1261_tps_programming_pkg.pkb
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-14/17/18
 @workstream        Programming / scheduling / rights / media availability
 @source_state      SOURCE_READY_PENDING_RUNTIME_COMPILE_TEST
 @production_state  NOT_DEPLOYED
 @reversibility     R1_ADDITIVE package body; invoked DML is R2_STATEFUL
 @purpose           Implement transactional programming rules: schedule creation, serialized
                    item insertion, overlap prevention, asset/readiness checks, fail-closed rights,
                    validation reporting, lifecycle approval/activation and current/next resolution.
 @business_impact   This is the first concrete PL/SQL business engine for autonomous/semi-autonomous
                    station programming. It is intended to replace direct schedule-table DML.
 @objects           Creates/replaces TPS_PROGRAMMING_PKG body.
 @dependencies      Package specification plus TPS_ENTITY, TPS_SCHEDULE, TPS_SCHEDULE_ITEM,
                    TPS_MEDIA_ASSET and TPS_RIGHTS_PKG.
 @upstream          Calls through TPS_PROGRAMMING_PKG.
 @downstream        Schedule state, playout resolution, continuity, API and AI tool wrappers.
 @d3ka_role         ENTITY/TEMPORAL/POLICY
 @d3ka_links        Owner/content are canonical D3KA entities; temporal windows govern programming;
                    rights policy gates execution.
 @ai_role           Deterministic executor/validator beneath AI. No model call occurs here.
 @security          AUTHID DEFINER. No dynamic SQL. No secret access. Direct table DML should be withheld.
 @performance       Serialized edit via schedule-row lock prevents race between overlap check and insert.
                    Validation is intentionally exhaustive before approval/activation; online resolution is short-circuit.
 @transaction       NO COMMIT/ROLLBACK anywhere. Caller controls transaction atomicity.
 @idempotency       See specification. Unique schedule key and overlap constraints/validation fail closed.
 @failure_modes     Application errors -20201..-20224 plus standard Oracle constraint/privilege errors.
 @rollback_recovery Caller rollback for uncommitted work; lifecycle/state transitions for committed history.
 @tests             tests/programming/* and tests/compile/COMP-001_programming_continuity.sql.
 @evidence          CORE-14/17/18 compile + behavioral + concurrency evidence.
 @references        Oracle AI Database 26ai PL/SQL Language Reference and SQL Language Reference.
 @links             src/12-media/1260_tps_programming_pkg.pks;
                    src/14-rights/1420_tps_rights_pkg.pkb;
                    src/12-media/1281_tps_continuity_pkg.pkb
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.02 2026-09-01 — initial implementation.
=============================================================================*/

CREATE OR REPLACE PACKAGE BODY tps_programming_pkg AS

  /* Internal validation engine. It deliberately reports counts instead of silently repairing data. */
  PROCEDURE collect_validation(
      p_schedule_id        IN NUMBER,
      o_owner_entity_id    OUT NUMBER,
      o_item_count         OUT NUMBER,
      o_overlap_count      OUT NUMBER,
      o_out_of_window      OUT NUMBER,
      o_missing_asset      OUT NUMBER,
      o_rights_not_allowed OUT NUMBER
  ) IS
      l_valid_from  TIMESTAMP WITH TIME ZONE;
      l_valid_to    TIMESTAMP WITH TIME ZONE;
      l_asset_count NUMBER;
      l_rights      VARCHAR2(40);
  BEGIN
      BEGIN
          SELECT owner_entity_id, valid_from, valid_to
            INTO o_owner_entity_id, l_valid_from, l_valid_to
            FROM tps_schedule
           WHERE schedule_id = p_schedule_id;
      EXCEPTION
          WHEN NO_DATA_FOUND THEN
              RAISE_APPLICATION_ERROR(-20220, 'TPS_PROGRAMMING_SCHEDULE_NOT_FOUND');
      END;

      SELECT COUNT(*)
        INTO o_item_count
        FROM tps_schedule_item
       WHERE schedule_id = p_schedule_id
         AND state = 'ACTIVE';

      /* Half-open interval overlap: A.start < B.end AND B.start < A.end. */
      SELECT COUNT(*)
        INTO o_overlap_count
        FROM tps_schedule_item a
        JOIN tps_schedule_item b
          ON b.schedule_id = a.schedule_id
         AND b.schedule_item_id > a.schedule_item_id
         AND a.start_at < b.end_at
         AND b.start_at < a.end_at
       WHERE a.schedule_id = p_schedule_id
         AND a.state = 'ACTIVE'
         AND b.state = 'ACTIVE';

      SELECT COUNT(*)
        INTO o_out_of_window
        FROM tps_schedule_item i
       WHERE i.schedule_id = p_schedule_id
         AND i.state = 'ACTIVE'
         AND (
              i.start_at < l_valid_from
              OR (l_valid_to IS NOT NULL AND i.end_at > l_valid_to)
         );

      o_missing_asset := 0;
      o_rights_not_allowed := 0;

      FOR r IN (
          SELECT schedule_item_id, content_entity_id, item_class, start_at
            FROM tps_schedule_item
           WHERE schedule_id = p_schedule_id
             AND state = 'ACTIVE'
           ORDER BY start_at, schedule_item_id
      ) LOOP
          /* LIVE items may be supplied by a real-time studio/source and therefore do not require a file asset. */
          IF UPPER(r.item_class) <> 'LIVE' THEN
              SELECT COUNT(*)
                INTO l_asset_count
                FROM tps_media_asset
               WHERE content_entity_id = r.content_entity_id
                 AND lifecycle_state = 'ACTIVE';
              IF l_asset_count = 0 THEN
                  o_missing_asset := o_missing_asset + 1;
              END IF;
          END IF;

          l_rights := tps_rights_pkg.decision_for(
              p_content_entity_id     => r.content_entity_id,
              p_beneficiary_entity_id => o_owner_entity_id,
              p_action_code           => 'BROADCAST',
              p_at                    => r.start_at
          );
          IF l_rights <> 'ALLOW' THEN
              o_rights_not_allowed := o_rights_not_allowed + 1;
          END IF;
      END LOOP;
  END collect_validation;

  FUNCTION create_schedule(
      p_schedule_key    IN VARCHAR2,
      p_owner_entity_id IN NUMBER,
      p_timezone_name   IN VARCHAR2,
      p_schedule_class  IN VARCHAR2,
      p_valid_from      IN TIMESTAMP WITH TIME ZONE,
      p_valid_to        IN TIMESTAMP WITH TIME ZONE DEFAULT NULL,
      p_precedence      IN NUMBER DEFAULT 100
  ) RETURN NUMBER IS
      l_dummy NUMBER;
      l_schedule_id NUMBER;
  BEGIN
      IF p_valid_from IS NULL OR (p_valid_to IS NOT NULL AND p_valid_to <= p_valid_from) THEN
          RAISE_APPLICATION_ERROR(-20202, 'TPS_PROGRAMMING_INVALID_SCHEDULE_VALIDITY');
      END IF;

      BEGIN
          SELECT entity_id
            INTO l_dummy
            FROM tps_entity
           WHERE entity_id = p_owner_entity_id
             AND state = 'ACTIVE';
      EXCEPTION
          WHEN NO_DATA_FOUND THEN
              RAISE_APPLICATION_ERROR(-20201, 'TPS_PROGRAMMING_OWNER_NOT_ACTIVE');
      END;

      INSERT INTO tps_schedule(
          schedule_key, owner_entity_id, timezone_name, precedence,
          schedule_class, state, valid_from, valid_to
      ) VALUES (
          TRIM(p_schedule_key), p_owner_entity_id, TRIM(p_timezone_name), p_precedence,
          UPPER(TRIM(p_schedule_class)), 'DRAFT', p_valid_from, p_valid_to
      ) RETURNING schedule_id INTO l_schedule_id;

      RETURN l_schedule_id;
  END create_schedule;

  FUNCTION add_schedule_item(
      p_schedule_id       IN NUMBER,
      p_content_entity_id IN NUMBER,
      p_context_id        IN NUMBER DEFAULT NULL,
      p_start_at          IN TIMESTAMP WITH TIME ZONE,
      p_end_at            IN TIMESTAMP WITH TIME ZONE,
      p_item_class        IN VARCHAR2,
      p_priority          IN NUMBER DEFAULT 100
  ) RETURN NUMBER IS
      l_owner_entity_id NUMBER;
      l_schedule_state  VARCHAR2(30);
      l_schedule_from   TIMESTAMP WITH TIME ZONE;
      l_schedule_to     TIMESTAMP WITH TIME ZONE;
      l_dummy            NUMBER;
      l_overlap_count    NUMBER;
      l_asset_count      NUMBER;
      l_rights           VARCHAR2(40);
      l_item_id          NUMBER;
      l_item_class       VARCHAR2(30) := UPPER(TRIM(p_item_class));
  BEGIN
      IF p_start_at IS NULL OR p_end_at IS NULL OR p_end_at <= p_start_at THEN
          RAISE_APPLICATION_ERROR(-20210, 'TPS_PROGRAMMING_INVALID_ITEM_TIME');
      END IF;

      /* Serialize all edits to one schedule so two sessions cannot both pass overlap validation. */
      BEGIN
          SELECT owner_entity_id, state, valid_from, valid_to
            INTO l_owner_entity_id, l_schedule_state, l_schedule_from, l_schedule_to
            FROM tps_schedule
           WHERE schedule_id = p_schedule_id
           FOR UPDATE;
      EXCEPTION
          WHEN NO_DATA_FOUND THEN
              RAISE_APPLICATION_ERROR(-20211, 'TPS_PROGRAMMING_SCHEDULE_NOT_FOUND');
      END;

      IF l_schedule_state <> 'DRAFT' THEN
          RAISE_APPLICATION_ERROR(-20212, 'TPS_PROGRAMMING_SCHEDULE_NOT_DRAFT');
      END IF;

      IF p_start_at < l_schedule_from
         OR (l_schedule_to IS NOT NULL AND p_end_at > l_schedule_to) THEN
          RAISE_APPLICATION_ERROR(-20213, 'TPS_PROGRAMMING_ITEM_OUTSIDE_SCHEDULE_WINDOW');
      END IF;

      BEGIN
          SELECT entity_id
            INTO l_dummy
            FROM tps_entity
           WHERE entity_id = p_content_entity_id
             AND state = 'ACTIVE';
      EXCEPTION
          WHEN NO_DATA_FOUND THEN
              RAISE_APPLICATION_ERROR(-20214, 'TPS_PROGRAMMING_CONTENT_NOT_ACTIVE');
      END;

      SELECT COUNT(*)
        INTO l_overlap_count
        FROM tps_schedule_item
       WHERE schedule_id = p_schedule_id
         AND state = 'ACTIVE'
         AND start_at < p_end_at
         AND p_start_at < end_at;

      IF l_overlap_count > 0 THEN
          RAISE_APPLICATION_ERROR(-20215, 'TPS_PROGRAMMING_ITEM_OVERLAP');
      END IF;

      IF l_item_class <> 'LIVE' THEN
          SELECT COUNT(*)
            INTO l_asset_count
            FROM tps_media_asset
           WHERE content_entity_id = p_content_entity_id
             AND lifecycle_state = 'ACTIVE';
          IF l_asset_count = 0 THEN
              RAISE_APPLICATION_ERROR(-20216, 'TPS_PROGRAMMING_ACTIVE_MEDIA_ASSET_REQUIRED');
          END IF;
      END IF;

      l_rights := tps_rights_pkg.decision_for(
          p_content_entity_id     => p_content_entity_id,
          p_beneficiary_entity_id => l_owner_entity_id,
          p_action_code           => 'BROADCAST',
          p_at                    => p_start_at
      );

      IF l_rights <> 'ALLOW' THEN
          RAISE_APPLICATION_ERROR(-20217, 'TPS_PROGRAMMING_RIGHTS_NOT_ALLOWED:' || NVL(l_rights,'NULL'));
      END IF;

      INSERT INTO tps_schedule_item(
          schedule_id, content_entity_id, context_id, start_at, end_at,
          item_class, priority, state
      ) VALUES (
          p_schedule_id, p_content_entity_id, p_context_id, p_start_at, p_end_at,
          l_item_class, p_priority, 'ACTIVE'
      ) RETURNING schedule_item_id INTO l_item_id;

      RETURN l_item_id;
  END add_schedule_item;

  FUNCTION validation_report(p_schedule_id IN NUMBER) RETURN CLOB IS
      l_owner_entity_id    NUMBER;
      l_item_count         NUMBER;
      l_overlap_count      NUMBER;
      l_out_of_window      NUMBER;
      l_missing_asset      NUMBER;
      l_rights_not_allowed NUMBER;
      l_valid              NUMBER;
      l_report             CLOB;
  BEGIN
      collect_validation(
          p_schedule_id, l_owner_entity_id, l_item_count, l_overlap_count,
          l_out_of_window, l_missing_asset, l_rights_not_allowed
      );

      l_valid := CASE
          WHEN l_item_count > 0
           AND l_overlap_count = 0
           AND l_out_of_window = 0
           AND l_missing_asset = 0
           AND l_rights_not_allowed = 0
          THEN 1 ELSE 0 END;

      SELECT JSON_OBJECT(
          'schedule_id' VALUE p_schedule_id,
          'owner_entity_id' VALUE l_owner_entity_id,
          'valid' VALUE l_valid,
          'item_count' VALUE l_item_count,
          'overlap_count' VALUE l_overlap_count,
          'out_of_window_count' VALUE l_out_of_window,
          'missing_asset_count' VALUE l_missing_asset,
          'rights_not_allowed_count' VALUE l_rights_not_allowed
          RETURNING CLOB
      )
      INTO l_report
      FROM dual;

      RETURN l_report;
  END validation_report;

  PROCEDURE approve_schedule(p_schedule_id IN NUMBER) IS
      l_state              VARCHAR2(30);
      l_owner_entity_id    NUMBER;
      l_item_count         NUMBER;
      l_overlap_count      NUMBER;
      l_out_of_window      NUMBER;
      l_missing_asset      NUMBER;
      l_rights_not_allowed NUMBER;
  BEGIN
      BEGIN
          SELECT state
            INTO l_state
            FROM tps_schedule
           WHERE schedule_id = p_schedule_id
           FOR UPDATE;
      EXCEPTION
          WHEN NO_DATA_FOUND THEN
              RAISE_APPLICATION_ERROR(-20220, 'TPS_PROGRAMMING_SCHEDULE_NOT_FOUND');
      END;

      IF l_state <> 'DRAFT' THEN
          RAISE_APPLICATION_ERROR(-20222, 'TPS_PROGRAMMING_APPROVAL_REQUIRES_DRAFT');
      END IF;

      collect_validation(
          p_schedule_id, l_owner_entity_id, l_item_count, l_overlap_count,
          l_out_of_window, l_missing_asset, l_rights_not_allowed
      );

      IF l_item_count = 0 OR l_overlap_count > 0 OR l_out_of_window > 0
         OR l_missing_asset > 0 OR l_rights_not_allowed > 0 THEN
          RAISE_APPLICATION_ERROR(-20221, 'TPS_PROGRAMMING_SCHEDULE_VALIDATION_FAILED');
      END IF;

      UPDATE tps_schedule
         SET state = 'APPROVED'
       WHERE schedule_id = p_schedule_id
         AND state = 'DRAFT';
  END approve_schedule;

  PROCEDURE activate_schedule(p_schedule_id IN NUMBER) IS
      l_owner_entity_id    NUMBER;
      l_schedule_class     VARCHAR2(30);
      l_state              VARCHAR2(30);
      l_valid_from         TIMESTAMP WITH TIME ZONE;
      l_valid_to           TIMESTAMP WITH TIME ZONE;
      l_item_count         NUMBER;
      l_overlap_count      NUMBER;
      l_out_of_window      NUMBER;
      l_missing_asset      NUMBER;
      l_rights_not_allowed NUMBER;
      l_conflict_count     NUMBER;
  BEGIN
      BEGIN
          SELECT owner_entity_id, schedule_class, state, valid_from, valid_to
            INTO l_owner_entity_id, l_schedule_class, l_state, l_valid_from, l_valid_to
            FROM tps_schedule
           WHERE schedule_id = p_schedule_id
           FOR UPDATE;
      EXCEPTION
          WHEN NO_DATA_FOUND THEN
              RAISE_APPLICATION_ERROR(-20220, 'TPS_PROGRAMMING_SCHEDULE_NOT_FOUND');
      END;

      IF l_state <> 'APPROVED' THEN
          RAISE_APPLICATION_ERROR(-20223, 'TPS_PROGRAMMING_ACTIVATION_REQUIRES_APPROVED');
      END IF;

      collect_validation(
          p_schedule_id, l_owner_entity_id, l_item_count, l_overlap_count,
          l_out_of_window, l_missing_asset, l_rights_not_allowed
      );

      IF l_item_count = 0 OR l_overlap_count > 0 OR l_out_of_window > 0
         OR l_missing_asset > 0 OR l_rights_not_allowed > 0 THEN
          RAISE_APPLICATION_ERROR(-20221, 'TPS_PROGRAMMING_SCHEDULE_VALIDATION_FAILED');
      END IF;

      SELECT COUNT(*)
        INTO l_conflict_count
        FROM tps_schedule s
       WHERE s.schedule_id <> p_schedule_id
         AND s.owner_entity_id = l_owner_entity_id
         AND s.schedule_class = l_schedule_class
         AND s.state = 'ACTIVE'
         AND (l_valid_to IS NULL OR s.valid_from < l_valid_to)
         AND (s.valid_to IS NULL OR l_valid_from < s.valid_to);

      IF l_conflict_count > 0 THEN
          RAISE_APPLICATION_ERROR(-20224, 'TPS_PROGRAMMING_ACTIVE_SCHEDULE_CONFLICT');
      END IF;

      UPDATE tps_schedule
         SET state = 'ACTIVE'
       WHERE schedule_id = p_schedule_id
         AND state = 'APPROVED';
  END activate_schedule;

  FUNCTION item_is_playable(
      p_schedule_item_id IN NUMBER,
      p_at               IN TIMESTAMP WITH TIME ZONE DEFAULT NULL
  ) RETURN NUMBER IS
      l_owner_entity_id NUMBER;
      l_content_entity_id NUMBER;
      l_item_class VARCHAR2(30);
      l_item_state VARCHAR2(30);
      l_schedule_state VARCHAR2(30);
      l_start_at TIMESTAMP WITH TIME ZONE;
      l_end_at TIMESTAMP WITH TIME ZONE;
      l_eval_at TIMESTAMP WITH TIME ZONE;
      l_asset_count NUMBER;
      l_rights VARCHAR2(40);
  BEGIN
      BEGIN
          SELECT s.owner_entity_id, i.content_entity_id, i.item_class, i.state,
                 s.state, i.start_at, i.end_at
            INTO l_owner_entity_id, l_content_entity_id, l_item_class, l_item_state,
                 l_schedule_state, l_start_at, l_end_at
            FROM tps_schedule_item i
            JOIN tps_schedule s ON s.schedule_id = i.schedule_id
           WHERE i.schedule_item_id = p_schedule_item_id;
      EXCEPTION
          WHEN NO_DATA_FOUND THEN
              RETURN 0;
      END;

      IF l_item_state <> 'ACTIVE' OR l_schedule_state <> 'ACTIVE' THEN
          RETURN 0;
      END IF;

      l_eval_at := COALESCE(p_at, l_start_at);
      IF l_eval_at < l_start_at OR l_eval_at >= l_end_at THEN
          RETURN 0;
      END IF;

      IF UPPER(l_item_class) <> 'LIVE' THEN
          SELECT COUNT(*)
            INTO l_asset_count
            FROM tps_media_asset
           WHERE content_entity_id = l_content_entity_id
             AND lifecycle_state = 'ACTIVE';
          IF l_asset_count = 0 THEN
              RETURN 0;
          END IF;
      END IF;

      l_rights := tps_rights_pkg.decision_for(
          p_content_entity_id     => l_content_entity_id,
          p_beneficiary_entity_id => l_owner_entity_id,
          p_action_code           => 'BROADCAST',
          p_at                    => l_eval_at
      );

      RETURN CASE WHEN l_rights = 'ALLOW' THEN 1 ELSE 0 END;
  END item_is_playable;

  FUNCTION current_item(
      p_owner_entity_id IN NUMBER,
      p_at              IN TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP
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
           ORDER BY s.precedence ASC, i.priority ASC, i.start_at DESC, i.schedule_item_id
      ) LOOP
          IF item_is_playable(r.schedule_item_id, p_at) = 1 THEN
              RETURN r.schedule_item_id;
          END IF;
      END LOOP;
      RETURN NULL;
  END current_item;

  FUNCTION next_item(
      p_owner_entity_id IN NUMBER,
      p_after           IN TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP
  ) RETURN NUMBER IS
  BEGIN
      FOR r IN (
          SELECT i.schedule_item_id, i.start_at
            FROM tps_schedule s
            JOIN tps_schedule_item i ON i.schedule_id = s.schedule_id
           WHERE s.owner_entity_id = p_owner_entity_id
             AND s.state = 'ACTIVE'
             AND (s.valid_to IS NULL OR p_after < s.valid_to)
             AND i.state = 'ACTIVE'
             AND i.start_at >= p_after
           ORDER BY i.start_at ASC, s.precedence ASC, i.priority ASC, i.schedule_item_id
      ) LOOP
          IF item_is_playable(r.schedule_item_id, r.start_at) = 1 THEN
              RETURN r.schedule_item_id;
          END IF;
      END LOOP;
      RETURN NULL;
  END next_item;

END tps_programming_pkg;
/
