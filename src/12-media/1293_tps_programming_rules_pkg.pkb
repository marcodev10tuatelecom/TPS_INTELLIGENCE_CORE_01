/*=============================================================================
 @file              src/12-media/1293_tps_programming_rules_pkg.pkb
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-11/14/17/18
 @workstream        Deterministic programming rules engine
 @source_state      SOURCE_READY_PENDING_RUNTIME_COMPILE_TEST
 @production_state  NOT_DEPLOYED
 @reversibility     R1_ADDITIVE
 @purpose           Implement schedule-level hard rules for repeat windows, rolling-hour
                    commercial load, program classification, exact media duration tolerance
                    and commercial-placement authorization.
 @business_impact   Makes broadcaster operational policy executable in Oracle PL/SQL and
                    mandatory at schedule APPROVED/ACTIVE state transitions.
 @objects           Creates/replaces TPS_PROGRAMMING_RULES_PKG body.
 @dependencies      Package spec, programming profile/schedule/items/program/rating/assets/placements.
 @upstream          Explicit validation and TPS_SCHEDULE_POLICY_GUARD trigger.
 @downstream        Approval/activation success or fail-closed rejection.
 @d3ka_role         POLICY/TEMPORAL/ENTITY
 @d3ka_links        Applies policy to owner/content identities and temporal programming relationships.
 @ai_role           Machine-readable report is AI planning input; ASSERT is non-probabilistic authority.
 @security          AUTHID DEFINER, static SQL only.
 @performance       Exhaustive approval-time validation; rolling-hour commercial checks are bounded
                    but O(C*N) for commercial items and require CORE-17 scale testing.
 @transaction       Read-only; no COMMIT/DML.
 @idempotency       Deterministic for consistent source state.
 @failure_modes     Missing profile, repeat, ad load, rating, duration or placement violations fail validation.
 @rollback_recovery Revert package source; no data mutation.
 @tests             tests/programming/PRG-910_rules_engine.sql.
 @evidence          CORE-11/14/17/18.
 @references        Oracle AI Database 26ai PL/SQL; NUMTODSINTERVAL; SYS_EXTRACT_UTC; SQL/JSON.
 @links             src/12-media/1292_tps_programming_rules_pkg.pks;
                    src/12-media/1294_tps_schedule_policy_guard_trg.sql;
                    src/13-commercial/1321_tps_commercial_pkg.pkb
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.03 2026-09-01 — initial implementation.
=============================================================================*/

CREATE OR REPLACE PACKAGE BODY tps_programming_rules_pkg AS

  FUNCTION seconds_between(
      p_from IN TIMESTAMP WITH TIME ZONE,
      p_to   IN TIMESTAMP WITH TIME ZONE
  ) RETURN NUMBER DETERMINISTIC IS
  BEGIN
      RETURN (CAST(SYS_EXTRACT_UTC(p_to) AS DATE) -
              CAST(SYS_EXTRACT_UTC(p_from) AS DATE)) * 86400;
  END seconds_between;

  PROCEDURE load_profile(
      p_owner_entity_id IN NUMBER,
      p_at              IN TIMESTAMP WITH TIME ZONE,
      o_found           OUT NUMBER,
      o_repeat_minutes  OUT NUMBER,
      o_max_ads_sec     OUT NUMBER,
      o_max_age         OUT NUMBER,
      o_require_rating  OUT NUMBER,
      o_duration_tol    OUT NUMBER,
      o_enforce_place   OUT NUMBER
  ) IS
  BEGIN
      o_found := 0;
      BEGIN
          SELECT repeat_window_minutes,
                 max_commercial_seconds_rolling_hour,
                 max_content_minimum_age,
                 require_program_rating,
                 asset_duration_tolerance_sec,
                 enforce_commercial_placement
            INTO o_repeat_minutes,
                 o_max_ads_sec,
                 o_max_age,
                 o_require_rating,
                 o_duration_tol,
                 o_enforce_place
            FROM tps_programming_rule_profile
           WHERE owner_entity_id = p_owner_entity_id
             AND state = 'ACTIVE'
             AND valid_from <= p_at
             AND (valid_to IS NULL OR p_at < valid_to);
          o_found := 1;
      EXCEPTION
          WHEN NO_DATA_FOUND THEN
              o_repeat_minutes := 0;
              o_max_ads_sec := 0;
              o_max_age := 0;
              o_require_rating := 1;
              o_duration_tol := 0;
              o_enforce_place := 1;
      END;
  END load_profile;

  /* @routine repeat_violation_count
     @purpose       Count earlier same-content items inside configured repeat window.
     @inputs        Schedule ID.
     @outputs       Pair count.
     @reads         Profile/schedule/items.
     @writes        NONE.
     @calls         LOAD_PROFILE.
     @called_by     SCHEDULE_REPORT.
     @d3ka_impact   Temporal content repetition policy.
     @ai_impact     Hard planning constraint.
     @security      Read-only.
     @transaction   Read-only.
     @performance   Owner/content/time join.
     @errors        -20602 missing schedule.
     @tests         PRG-910.
  */
  FUNCTION repeat_violation_count(p_schedule_id IN NUMBER) RETURN NUMBER IS
      l_owner_entity_id NUMBER;
      l_schedule_from TIMESTAMP WITH TIME ZONE;
      l_found NUMBER;
      l_repeat NUMBER;
      l_ads NUMBER;
      l_age NUMBER;
      l_req NUMBER;
      l_tol NUMBER;
      l_place NUMBER;
      l_count NUMBER := 0;
  BEGIN
      BEGIN
          SELECT owner_entity_id, valid_from
            INTO l_owner_entity_id, l_schedule_from
            FROM tps_schedule
           WHERE schedule_id = p_schedule_id;
      EXCEPTION
          WHEN NO_DATA_FOUND THEN
              RAISE_APPLICATION_ERROR(-20602,'TPS_PROGRAMMING_RULES_SCHEDULE_NOT_FOUND');
      END;

      load_profile(l_owner_entity_id,l_schedule_from,l_found,l_repeat,l_ads,l_age,l_req,l_tol,l_place);
      IF l_found = 0 OR l_repeat = 0 THEN
          RETURN 0;
      END IF;

      SELECT COUNT(*)
        INTO l_count
        FROM tps_schedule_item i
        JOIN tps_schedule si ON si.schedule_id = i.schedule_id
        JOIN tps_schedule_item j ON j.content_entity_id = i.content_entity_id
                                AND j.schedule_item_id <> i.schedule_item_id
        JOIN tps_schedule sj ON sj.schedule_id = j.schedule_id
       WHERE i.schedule_id = p_schedule_id
         AND i.state = 'ACTIVE'
         AND j.state IN ('ACTIVE','PLAYED')
         AND sj.owner_entity_id = si.owner_entity_id
         AND (sj.schedule_id = p_schedule_id OR sj.state IN ('ACTIVE','SUPERSEDED'))
         AND j.start_at < i.start_at
         AND j.start_at >= i.start_at - NUMTODSINTERVAL(l_repeat,'MINUTE');

      RETURN l_count;
  END repeat_violation_count;

  /* @routine commercial_seconds_rolling_hour
     @purpose       Calculate actual commercial overlap in [window_end-60m, window_end).
     @inputs        Owner entity and window end.
     @outputs       Seconds.
     @reads         Active schedule/items.
     @writes        NONE.
     @calls         SECONDS_BETWEEN.
     @called_by     External diagnostics; SCHEDULE_REPORT uses a validation variant including draft schedule.
     @d3ka_impact   Temporal commercial-load policy.
     @ai_impact     Hard metric.
     @security      Read-only.
     @transaction   Read-only.
     @performance   Bounded one-hour scan.
     @errors        Standard Oracle errors.
     @tests         PRG-910.
  */
  FUNCTION commercial_seconds_rolling_hour(
      p_owner_entity_id IN NUMBER,
      p_window_end      IN TIMESTAMP WITH TIME ZONE
  ) RETURN NUMBER IS
      l_window_start TIMESTAMP WITH TIME ZONE := p_window_end - NUMTODSINTERVAL(60,'MINUTE');
      l_clip_start TIMESTAMP WITH TIME ZONE;
      l_clip_end   TIMESTAMP WITH TIME ZONE;
      l_total NUMBER := 0;
  BEGIN
      FOR r IN (
          SELECT i.start_at, i.end_at
            FROM tps_schedule s
            JOIN tps_schedule_item i ON i.schedule_id = s.schedule_id
           WHERE s.owner_entity_id = p_owner_entity_id
             AND s.state = 'ACTIVE'
             AND i.state IN ('ACTIVE','PLAYED')
             AND i.item_class = 'COMMERCIAL'
             AND i.start_at < p_window_end
             AND i.end_at > l_window_start
      ) LOOP
          l_clip_start := CASE WHEN r.start_at > l_window_start THEN r.start_at ELSE l_window_start END;
          l_clip_end := CASE WHEN r.end_at < p_window_end THEN r.end_at ELSE p_window_end END;
          l_total := l_total + GREATEST(0, seconds_between(l_clip_start,l_clip_end));
      END LOOP;
      RETURN ROUND(l_total,3);
  END commercial_seconds_rolling_hour;

  FUNCTION commercial_seconds_for_validation(
      p_owner_entity_id IN NUMBER,
      p_schedule_id     IN NUMBER,
      p_window_end      IN TIMESTAMP WITH TIME ZONE
  ) RETURN NUMBER IS
      l_window_start TIMESTAMP WITH TIME ZONE := p_window_end - NUMTODSINTERVAL(60,'MINUTE');
      l_clip_start TIMESTAMP WITH TIME ZONE;
      l_clip_end   TIMESTAMP WITH TIME ZONE;
      l_total NUMBER := 0;
  BEGIN
      FOR r IN (
          SELECT i.start_at, i.end_at
            FROM tps_schedule s
            JOIN tps_schedule_item i ON i.schedule_id = s.schedule_id
           WHERE s.owner_entity_id = p_owner_entity_id
             AND (s.schedule_id = p_schedule_id OR s.state = 'ACTIVE')
             AND i.state IN ('ACTIVE','PLAYED')
             AND i.item_class = 'COMMERCIAL'
             AND i.start_at < p_window_end
             AND i.end_at > l_window_start
      ) LOOP
          l_clip_start := CASE WHEN r.start_at > l_window_start THEN r.start_at ELSE l_window_start END;
          l_clip_end := CASE WHEN r.end_at < p_window_end THEN r.end_at ELSE p_window_end END;
          l_total := l_total + GREATEST(0, seconds_between(l_clip_start,l_clip_end));
      END LOOP;
      RETURN ROUND(l_total,3);
  END commercial_seconds_for_validation;

  /* @routine schedule_report
     @purpose       Calculate all extended policy violations and emit JSON.
     @inputs        Schedule ID.
     @outputs       CLOB JSON.
     @reads         Profile/schedule/items/program/rating/assets/placements.
     @writes        NONE.
     @calls         REPEAT_VIOLATION_COUNT, COMMERCIAL_SECONDS_FOR_VALIDATION.
     @called_by     ASSERT_SCHEDULE_RULES, AI/API/tests.
     @d3ka_impact   Policy result over owner/content/time.
     @ai_impact     Structured hard-rule feedback for planning.
     @security      Read-only.
     @transaction   Read-only.
     @performance   Exhaustive schedule validation.
     @errors        -20602 missing schedule.
     @tests         PRG-910.
  */
  FUNCTION schedule_report(p_schedule_id IN NUMBER) RETURN CLOB IS
      l_owner_entity_id NUMBER;
      l_schedule_from TIMESTAMP WITH TIME ZONE;
      l_found NUMBER;
      l_repeat NUMBER;
      l_max_ads NUMBER;
      l_max_age NUMBER;
      l_require_rating NUMBER;
      l_duration_tol NUMBER;
      l_enforce_place NUMBER;
      l_repeat_viol NUMBER := 0;
      l_ads_viol NUMBER := 0;
      l_rating_viol NUMBER := 0;
      l_duration_viol NUMBER := 0;
      l_placement_viol NUMBER := 0;
      l_asset_match NUMBER;
      l_scheduled_sec NUMBER;
      l_rating_age NUMBER;
      l_place_count NUMBER;
      l_total_ads NUMBER;
      l_valid NUMBER;
      l_report CLOB;
  BEGIN
      BEGIN
          SELECT owner_entity_id, valid_from
            INTO l_owner_entity_id, l_schedule_from
            FROM tps_schedule
           WHERE schedule_id = p_schedule_id;
      EXCEPTION
          WHEN NO_DATA_FOUND THEN
              RAISE_APPLICATION_ERROR(-20602,'TPS_PROGRAMMING_RULES_SCHEDULE_NOT_FOUND');
      END;

      load_profile(
          l_owner_entity_id,l_schedule_from,l_found,l_repeat,l_max_ads,l_max_age,
          l_require_rating,l_duration_tol,l_enforce_place
      );

      IF l_found = 1 THEN
          l_repeat_viol := repeat_violation_count(p_schedule_id);

          FOR r IN (
              SELECT schedule_item_id, content_entity_id, item_class, start_at, end_at
                FROM tps_schedule_item
               WHERE schedule_id = p_schedule_id
                 AND state = 'ACTIVE'
          ) LOOP
              IF r.item_class <> 'LIVE' THEN
                  l_scheduled_sec := seconds_between(r.start_at,r.end_at);
                  SELECT COUNT(*)
                    INTO l_asset_match
                    FROM tps_media_asset a
                   WHERE a.content_entity_id = r.content_entity_id
                     AND a.lifecycle_state = 'ACTIVE'
                     AND a.duration_ms IS NOT NULL
                     AND ABS((a.duration_ms / 1000) - l_scheduled_sec) <= l_duration_tol;
                  IF l_asset_match = 0 THEN
                      l_duration_viol := l_duration_viol + 1;
                  END IF;
              END IF;

              IF r.item_class = 'PROGRAM' THEN
                  l_rating_age := NULL;
                  BEGIN
                      SELECT cr.minimum_age
                        INTO l_rating_age
                        FROM tps_program p
                        JOIN tps_content_rating cr
                          ON cr.rating_code = UPPER(TRIM(p.editorial_rating))
                         AND cr.state = 'ACTIVE'
                       WHERE p.program_entity_id = r.content_entity_id;
                  EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                          l_rating_age := NULL;
                  END;

                  IF l_rating_age IS NULL THEN
                      IF l_require_rating = 1 THEN
                          l_rating_viol := l_rating_viol + 1;
                      END IF;
                  ELSIF l_rating_age > l_max_age THEN
                      l_rating_viol := l_rating_viol + 1;
                  END IF;
              END IF;

              IF r.item_class = 'COMMERCIAL' AND l_enforce_place = 1 THEN
                  SELECT COUNT(*)
                    INTO l_place_count
                    FROM tps_placement p
                   WHERE p.schedule_item_id = r.schedule_item_id
                     AND p.state IN ('AUTHORIZED','PLAYED');
                  IF l_place_count = 0 THEN
                      l_placement_viol := l_placement_viol + 1;
                  END IF;
              END IF;
          END LOOP;

          FOR c IN (
              SELECT end_at
                FROM tps_schedule_item
               WHERE schedule_id = p_schedule_id
                 AND state = 'ACTIVE'
                 AND item_class = 'COMMERCIAL'
          ) LOOP
              l_total_ads := commercial_seconds_for_validation(
                  l_owner_entity_id,p_schedule_id,c.end_at
              );
              IF l_total_ads > l_max_ads THEN
                  l_ads_viol := l_ads_viol + 1;
              END IF;
          END LOOP;
      END IF;

      l_valid := CASE
          WHEN l_found = 1
           AND l_repeat_viol = 0
           AND l_ads_viol = 0
           AND l_rating_viol = 0
           AND l_duration_viol = 0
           AND l_placement_viol = 0
          THEN 1 ELSE 0 END;

      SELECT JSON_OBJECT(
          'schedule_id' VALUE p_schedule_id,
          'owner_entity_id' VALUE l_owner_entity_id,
          'valid' VALUE l_valid,
          'profile_found' VALUE l_found,
          'repeat_violation_count' VALUE l_repeat_viol,
          'commercial_load_violation_count' VALUE l_ads_viol,
          'rating_violation_count' VALUE l_rating_viol,
          'duration_violation_count' VALUE l_duration_viol,
          'placement_violation_count' VALUE l_placement_viol,
          'repeat_window_minutes' VALUE l_repeat,
          'max_commercial_seconds_rolling_hour' VALUE l_max_ads,
          'max_content_minimum_age' VALUE l_max_age,
          'asset_duration_tolerance_sec' VALUE l_duration_tol
          RETURNING CLOB
      ) INTO l_report FROM dual;

      RETURN l_report;
  END schedule_report;

  /* @routine assert_schedule_rules
     @purpose       Raise unless full extended programming policy passes.
     @inputs        Schedule ID.
     @outputs       NONE.
     @reads         Same as report.
     @writes        NONE.
     @calls         SCHEDULE_REPORT.
     @called_by     State guard trigger.
     @d3ka_impact   Hard policy gate.
     @ai_impact     Non-overridable.
     @security      Read-only definer package.
     @transaction   Read-only; exception aborts attempted state transition.
     @performance   Exhaustive approval-time validation.
     @errors        -20601 invalid schedule policy.
     @tests         PRG-910.
  */
  PROCEDURE assert_schedule_rules(p_schedule_id IN NUMBER) IS
      l_report CLOB;
      l_valid NUMBER;
  BEGIN
      l_report := schedule_report(p_schedule_id);
      SELECT JSON_VALUE(l_report,'$.valid' RETURNING NUMBER)
        INTO l_valid
        FROM dual;
      IF NVL(l_valid,0) <> 1 THEN
          RAISE_APPLICATION_ERROR(-20601,'TPS_PROGRAMMING_EXTENDED_RULES_FAILED');
      END IF;
  END assert_schedule_rules;

END tps_programming_rules_pkg;
/
