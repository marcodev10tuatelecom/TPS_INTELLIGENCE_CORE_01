-- TPSDBCORE01 | CORE-07 | TEST SOURCE | NOT EXECUTED AGAINST PRODUCTION
-- Requires tps_temporal_pkg compiled in an authorized test/deployment context.
SET SERVEROUTPUT ON
DECLARE
  PROCEDURE assert_eq(p_name VARCHAR2, p_actual NUMBER, p_expected NUMBER) IS
  BEGIN
    IF p_actual != p_expected THEN
      RAISE_APPLICATION_ERROR(-20000, p_name || ': expected=' || p_expected || ', actual=' || p_actual);
    END IF;
    DBMS_OUTPUT.PUT_LINE('PASS=' || p_name);
  END;
  t0 TIMESTAMP WITH TIME ZONE := TO_TIMESTAMP_TZ('2026-01-01 00:00:00 +00:00','YYYY-MM-DD HH24:MI:SS TZH:TZM');
  t1 TIMESTAMP WITH TIME ZONE := TO_TIMESTAMP_TZ('2026-01-02 00:00:00 +00:00','YYYY-MM-DD HH24:MI:SS TZH:TZM');
  t2 TIMESTAMP WITH TIME ZONE := TO_TIMESTAMP_TZ('2026-01-03 00:00:00 +00:00','YYYY-MM-DD HH24:MI:SS TZH:TZM');
BEGIN
  assert_eq('contains_start_inclusive', tps_temporal_pkg.interval_contains(t0,t2,t0), 1);
  assert_eq('contains_inside',          tps_temporal_pkg.interval_contains(t0,t2,t1), 1);
  assert_eq('contains_end_exclusive',   tps_temporal_pkg.interval_contains(t0,t2,t2), 0);
  assert_eq('contains_open_end',        tps_temporal_pkg.interval_contains(t0,NULL,t2), 1);
  assert_eq('contains_null_start',      tps_temporal_pkg.interval_contains(NULL,t2,t1), 0);
  assert_eq('overlap_intersect',        tps_temporal_pkg.intervals_overlap(t0,t2,t1,NULL), 1);
  assert_eq('overlap_touching_end',     tps_temporal_pkg.intervals_overlap(t0,t1,t1,t2), 0);
  assert_eq('overlap_open_end',         tps_temporal_pkg.intervals_overlap(t0,NULL,t2,NULL), 1);
  DBMS_OUTPUT.PUT_LINE('TEMPORAL_TEST_STATUS=PASS');
END;
/