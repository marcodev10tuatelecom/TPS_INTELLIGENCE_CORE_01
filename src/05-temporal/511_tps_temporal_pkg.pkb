/*=============================================================================
 @file              src/05-temporal/511_tps_temporal_pkg.pkb
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-07
 @workstream        WS-08 Temporal engine
 @source_state      SOURCE_READY
 @production_state  NOT_DEPLOYED
 @reversibility     R1_ADDITIVE
 @purpose           Implement deterministic half-open interval predicates used by
                    D3KA and domain code for temporal consistency.
 @business_impact   Prevents different applications/domains from interpreting validity
                    windows differently, especially programming, rights and campaigns.
 @objects           Creates/replaces package body TPS_TEMPORAL_PKG.
 @dependencies      TPS_TEMPORAL_PKG specification.
 @upstream          Calls through TPS_TEMPORAL_PKG public contract.
 @downstream        D3KA temporal checks, rights/schedule/campaign logic and test suites.
 @d3ka_role         TEMPORAL
 @d3ka_links        Implements Tv point containment and Tv-to-Tv overlap semantics.
 @ai_role           NONE directly; deterministic results may be used as AI context but
                    remain independent of probabilistic reasoning.
 @security          No table access, secrets, dynamic SQL or external calls.
 @performance       Constant-time timestamp comparisons only.
 @transaction       Pure/read-only; no DML, COMMIT, ROLLBACK or locks.
 @idempotency       CREATE OR REPLACE body is repeatable when specification is compatible.
 @failure_modes     Null interval starts/point return 0. Open end NULL means unbounded future.
                    Invalid caller assumptions about interval ordering are not normalized here;
                    base-table constraints/domain tests must prevent invalid windows.
 @rollback_recovery Restore previous package body; no persisted business state is modified.
 @tests             tests/temporal/test_temporal_pkg.sql.
 @evidence          CORE-07 deterministic temporal test output and CORE-20 certification.
 @references        Oracle AI Database 26ai PL/SQL Language Reference; timestamp comparison semantics.
 @links             src/05-temporal/510_tps_temporal_pkg.pks;
                    src/05-temporal/500_tps_relation_current_v.sql;
                    docs/04-d3ka/D3KA-ENGINEERING-SPEC-v0.02.md
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.02 2026-09-01 — expanded full embedded/routine docs; behavior unchanged.
=============================================================================*/

CREATE OR REPLACE PACKAGE BODY tps_temporal_pkg AS

  /* @routine interval_contains
     @purpose       Evaluate point containment under [from,to) semantics.
     @inputs        Start, optional end, point timestamp.
     @outputs       NUMBER 1=true, 0=false.
     @reads         NONE.
     @writes        NONE.
     @calls         NONE.
     @called_by     Temporal/domain validation.
     @d3ka_impact   Determines whether one D3KA Tv interval is valid at a point.
     @ai_impact     NONE.
     @security      No data access.
     @transaction   Pure function; no SQL transaction side effects.
     @performance   O(1).
     @errors        No custom errors. NULL start or point returns 0.
     @tests         tests/temporal/test_temporal_pkg.sql.
  */
  FUNCTION interval_contains(
      p_valid_from IN TIMESTAMP WITH TIME ZONE,
      p_valid_to   IN TIMESTAMP WITH TIME ZONE,
      p_at         IN TIMESTAMP WITH TIME ZONE
  ) RETURN NUMBER DETERMINISTIC IS
  BEGIN
    IF p_valid_from IS NULL OR p_at IS NULL THEN
      RETURN 0;
    END IF;
    IF p_valid_from <= p_at AND (p_valid_to IS NULL OR p_at < p_valid_to) THEN
      RETURN 1;
    END IF;
    RETURN 0;
  END interval_contains;

  /* @routine intervals_overlap
     @purpose       Evaluate whether two [from,to) intervals share any instant.
     @inputs        A/B start timestamps plus optional unbounded end timestamps.
     @outputs       NUMBER 1=overlap, 0=no overlap/invalid null start.
     @reads         NONE.
     @writes        NONE.
     @calls         NONE.
     @called_by     D3KA/domain temporal collision checks.
     @d3ka_impact   Detects intersecting Tv windows.
     @ai_impact     NONE.
     @security      No data access.
     @transaction   Pure function; no SQL transaction side effects.
     @performance   O(1).
     @errors        No custom errors. NULL start returns 0.
     @tests         tests/temporal/test_temporal_pkg.sql.
  */
  FUNCTION intervals_overlap(
      p_a_from IN TIMESTAMP WITH TIME ZONE,
      p_a_to   IN TIMESTAMP WITH TIME ZONE,
      p_b_from IN TIMESTAMP WITH TIME ZONE,
      p_b_to   IN TIMESTAMP WITH TIME ZONE
  ) RETURN NUMBER DETERMINISTIC IS
  BEGIN
    IF p_a_from IS NULL OR p_b_from IS NULL THEN
      RETURN 0;
    END IF;
    IF (p_a_to IS NULL OR p_b_from < p_a_to)
       AND (p_b_to IS NULL OR p_a_from < p_b_to) THEN
      RETURN 1;
    END IF;
    RETURN 0;
  END intervals_overlap;
END tps_temporal_pkg;
/