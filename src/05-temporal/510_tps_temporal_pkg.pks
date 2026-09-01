-- FILE_ID: TEMP-510
-- TPSDBCORE01 | CORE-07 | R1 ADDITIVE | SOURCE_READY | NOT DEPLOYED
-- PURPOSE: deterministic temporal predicates shared by D3KA/domain code.
-- D3KA_ROLE: D3KA_TEMPORAL
-- DEPENDS: none
-- TESTS: tests/temporal/test_temporal_pkg.sql
CREATE OR REPLACE PACKAGE tps_temporal_pkg AUTHID DEFINER AS
  FUNCTION interval_contains(
      p_valid_from IN TIMESTAMP WITH TIME ZONE,
      p_valid_to   IN TIMESTAMP WITH TIME ZONE,
      p_at         IN TIMESTAMP WITH TIME ZONE
  ) RETURN NUMBER DETERMINISTIC;

  FUNCTION intervals_overlap(
      p_a_from IN TIMESTAMP WITH TIME ZONE,
      p_a_to   IN TIMESTAMP WITH TIME ZONE,
      p_b_from IN TIMESTAMP WITH TIME ZONE,
      p_b_to   IN TIMESTAMP WITH TIME ZONE
  ) RETURN NUMBER DETERMINISTIC;
END tps_temporal_pkg;
/