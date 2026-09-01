/*=============================================================================
 @file              src/05-temporal/510_tps_temporal_pkg.pks
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-07
 @workstream        WS-08 Temporal engine
 @source_state      SOURCE_READY
 @production_state  NOT_DEPLOYED
 @reversibility     R1_ADDITIVE
 @purpose           Expose deterministic half-open interval predicates used by D3KA
                    and domain code to answer point-in-time containment and interval overlap
                    without duplicating temporal logic.
 @business_impact   Gives schedules, rights, campaigns, relations and editorial validity
                    one consistent temporal interpretation across every media application.
 @objects           Creates/replaces package specification TPS_TEMPORAL_PKG.
 @dependencies      None for the specification.
 @upstream          Domain/knowledge code requiring common temporal predicates.
 @downstream        D3KA temporal logic, rights/scheduling/policy/domain routines and tests.
 @d3ka_role         TEMPORAL
 @d3ka_links        Implements Tv interval predicates; open-ended VALID_TO=NULL is treated
                    as unbounded future. Interval convention is [from,to).
 @ai_role           AI may use temporal results as context; predicates are deterministic and
                    do not delegate authority to AI.
 @security          Pure deterministic functions over caller-provided timestamps; no table access.
 @performance       O(1) scalar comparisons only; suitable for deterministic reuse, while
                    set-based SQL should remain preferred for large row-set filtering.
 @transaction       No SQL DML, commits or locks.
 @idempotency       CREATE OR REPLACE package spec is repeatable if dependent body is revalidated.
 @failure_modes     NULL start or point values produce explicit 0 according to implementation;
                    callers must not interpret 0 as proof that invalid data is otherwise valid.
 @rollback_recovery Restore prior package specification/body source; no business data affected.
 @tests             tests/temporal/test_temporal_pkg.sql.
 @evidence          CORE-07 function tests and CORE-20 certification.
 @references        Oracle AI Database 26ai PL/SQL Language Reference; TIMESTAMP WITH TIME ZONE.
 @links             src/05-temporal/511_tps_temporal_pkg.pkb;
                    src/05-temporal/500_tps_relation_current_v.sql;
                    docs/04-d3ka/D3KA-ENGINEERING-SPEC-v0.02.md
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.02 2026-09-01 — expanded full embedded/routine docs; API unchanged.
=============================================================================*/

CREATE OR REPLACE PACKAGE tps_temporal_pkg AUTHID DEFINER AS

  /* @routine interval_contains
     @purpose       Test whether p_at lies inside half-open interval [p_valid_from,p_valid_to).
     @inputs        p_valid_from mandatory logical start; p_valid_to optional open end;
                    p_at point in time to evaluate.
     @outputs       1 when contained, otherwise 0.
     @reads         NONE.
     @writes        NONE.
     @calls         NONE.
     @called_by     D3KA/domain temporal validation and tests.
     @d3ka_impact   Evaluates Tv dimension of one logical cell/window.
     @ai_impact     NONE; deterministic temporal predicate.
     @security      No data access.
     @transaction   Pure/read-only, no SQL transaction.
     @performance   O(1) timestamp comparisons.
     @errors        No custom exceptions; null start/point returns 0 in body.
     @tests         tests/temporal/test_temporal_pkg.sql.
  */
  FUNCTION interval_contains(
      p_valid_from IN TIMESTAMP WITH TIME ZONE,
      p_valid_to   IN TIMESTAMP WITH TIME ZONE,
      p_at         IN TIMESTAMP WITH TIME ZONE
  ) RETURN NUMBER DETERMINISTIC;

  /* @routine intervals_overlap
     @purpose       Determine whether two half-open intervals intersect.
     @inputs        A and B starts plus optional open-ended end timestamps.
     @outputs       1 when the intervals overlap, otherwise 0.
     @reads         NONE.
     @writes        NONE.
     @calls         NONE.
     @called_by     Scheduling, rights, campaign and D3KA temporal validation.
     @d3ka_impact   Detects Tv collisions/overlap among temporal cells/windows.
     @ai_impact     NONE; deterministic temporal predicate.
     @security      No data access.
     @transaction   Pure/read-only, no SQL transaction.
     @performance   O(1) timestamp comparisons.
     @errors        No custom exceptions; null start returns 0 in body.
     @tests         tests/temporal/test_temporal_pkg.sql.
  */
  FUNCTION intervals_overlap(
      p_a_from IN TIMESTAMP WITH TIME ZONE,
      p_a_to   IN TIMESTAMP WITH TIME ZONE,
      p_b_from IN TIMESTAMP WITH TIME ZONE,
      p_b_to   IN TIMESTAMP WITH TIME ZONE
  ) RETURN NUMBER DETERMINISTIC;
END tps_temporal_pkg;
/