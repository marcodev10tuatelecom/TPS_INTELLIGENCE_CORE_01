-- FILE_ID: TEMP-511
-- TPSDBCORE01 | CORE-07 | R1 ADDITIVE | SOURCE_READY | NOT DEPLOYED
-- PURPOSE: temporal predicate implementation.
-- D3KA_ROLE: D3KA_TEMPORAL
-- DEPENDS: TPS_TEMPORAL_PKG spec
-- TESTS: tests/temporal/test_temporal_pkg.sql
CREATE OR REPLACE PACKAGE BODY tps_temporal_pkg AS
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