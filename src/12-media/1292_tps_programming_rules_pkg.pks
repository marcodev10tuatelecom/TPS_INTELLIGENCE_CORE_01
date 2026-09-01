/*=============================================================================
 @file              src/12-media/1292_tps_programming_rules_pkg.pks
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-11/14/17/18
 @workstream        Deterministic programming rules engine
 @source_state      SOURCE_READY_PENDING_RUNTIME_COMPILE_TEST
 @production_state  NOT_DEPLOYED
 @reversibility     R1_ADDITIVE
 @purpose           Expose database-enforced schedule policy for repeat windows, commercial
                    load, age classification, media duration and authorized commercial placements.
 @business_impact   Converts broadcaster-group operational rules into PL/SQL invariants that
                    humans, applications and AI must all satisfy before a schedule becomes APPROVED/ACTIVE.
 @objects           Creates/replaces TPS_PROGRAMMING_RULES_PKG specification.
 @dependencies      TPS_PROGRAMMING_RULE_PROFILE, TPS_SCHEDULE, TPS_SCHEDULE_ITEM, TPS_PROGRAM,
                    TPS_CONTENT_RATING, TPS_MEDIA_ASSET, TPS_PLACEMENT.
 @upstream          Schedule approval/activation and state guard trigger.
 @downstream        Programming state transitions, audit/tests and AI planning context.
 @d3ka_role         POLICY/TEMPORAL/ENTITY
 @d3ka_links        Rules apply to canonical owner/content entities and their temporal schedule relationships.
 @ai_role           AI can query report and optimize; ASSERT_SCHEDULE_RULES is deterministic authority.
 @security          AUTHID DEFINER; normal runtime roles should execute package, not alter policy tables.
 @performance       Validation is batch/exhaustive at approval; not intended for per-frame playout execution.
 @transaction       Read-only package. No commit/DML.
 @idempotency       Same consistent state yields same report.
 @failure_modes     Missing active profile is a policy failure. ASSERT raises -20601 on violations.
 @rollback_recovery Replace prior package version; no persistent data changed by this package.
 @tests             tests/programming/PRG-910_rules_engine.sql.
 @evidence          CORE-11/14/17/18.
 @references        Oracle AI Database 26ai PL/SQL/SQL Language Reference.
 @links             src/12-media/1291_tps_programming_rule_profile.sql;
                    src/12-media/1293_tps_programming_rules_pkg.pkb;
                    src/12-media/1294_tps_schedule_policy_guard_trg.sql
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.03 2026-09-01 — initial implementation.
=============================================================================*/

CREATE OR REPLACE PACKAGE tps_programming_rules_pkg AUTHID DEFINER AS

  /* @routine repeat_violation_count
     @purpose       Count repeated content inside the configured owner repeat window.
     @inputs        Schedule ID.
     @outputs       Number of violating item/prior-item pairs.
     @reads         Schedule/profile/items.
     @writes        NONE.
     @calls         NONE.
     @called_by     SCHEDULE_REPORT.
     @d3ka_impact   Temporal policy over content/owner entities.
     @ai_impact     Deterministic constraint for AI scheduling.
     @security      Read-only.
     @transaction   Read-only.
     @performance   Join bounded by owner/time/content; indexes required for scale certification.
     @errors        -20602 schedule missing; missing profile returns zero here but report marks profile_missing.
     @tests         PRG-910.
  */
  FUNCTION repeat_violation_count(p_schedule_id IN NUMBER) RETURN NUMBER;

  /* @routine commercial_seconds_rolling_hour
     @purpose       Calculate commercial seconds overlapping a 60-minute window ending at p_window_end.
     @inputs        Owner entity and window end timestamp.
     @outputs       Non-negative commercial seconds.
     @reads         TPS_SCHEDULE/TPS_SCHEDULE_ITEM.
     @writes        NONE.
     @calls         NONE.
     @called_by     SCHEDULE_REPORT.
     @d3ka_impact   Temporal commercial policy over owner entity.
     @ai_impact     Deterministic ad-load metric.
     @security      Read-only.
     @transaction   Read-only.
     @performance   Bounded one-hour scan; requires time index evidence.
     @errors        Standard Oracle errors.
     @tests         PRG-910.
  */
  FUNCTION commercial_seconds_rolling_hour(
      p_owner_entity_id IN NUMBER,
      p_window_end      IN TIMESTAMP WITH TIME ZONE
  ) RETURN NUMBER;

  /* @routine schedule_report
     @purpose       Return JSON containing all extended programming-policy violation counts.
     @inputs        Schedule ID.
     @outputs       CLOB JSON with valid/profile/violation metrics.
     @reads         Programming, policy, media, rating and placement tables.
     @writes        NONE.
     @calls         REPEAT_VIOLATION_COUNT, COMMERCIAL_SECONDS_ROLLING_HOUR.
     @called_by     ASSERT_SCHEDULE_RULES, APIs, AI context, tests.
     @d3ka_impact   Policy validation over temporal content/owner graph identities.
     @ai_impact     Machine-readable hard-rule report for AI planning.
     @security      Does not reveal credentials/secrets.
     @transaction   Read-only.
     @performance   Exhaustive approval-time scan.
     @errors        -20602 missing schedule; malformed dependent data may propagate errors.
     @tests         PRG-910.
  */
  FUNCTION schedule_report(p_schedule_id IN NUMBER) RETURN CLOB;

  /* @routine assert_schedule_rules
     @purpose       Fail closed unless SCHEDULE_REPORT is valid=1.
     @inputs        Schedule ID.
     @outputs       NONE on PASS.
     @reads         Same as SCHEDULE_REPORT.
     @writes        NONE.
     @calls         SCHEDULE_REPORT.
     @called_by     Schedule state guard trigger and explicit validators.
     @d3ka_impact   Deterministic policy gate.
     @ai_impact     Non-overridable hard boundary.
     @security      Definer-rights read validation.
     @transaction   Read-only; raising aborts caller statement/transaction scope according to caller handling.
     @performance   Same as report.
     @errors        -20601 when invalid.
     @tests         PRG-910.
  */
  PROCEDURE assert_schedule_rules(p_schedule_id IN NUMBER);

END tps_programming_rules_pkg;
/
