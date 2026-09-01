-- CORE-11/14 CERTIFICATION | R0
SELECT state,COUNT(*) FROM tps_schedule GROUP BY state ORDER BY state;
SELECT state,decision,COUNT(*) FROM tps_right_grant GROUP BY state,decision ORDER BY state,decision;

SELECT COUNT(*) AS invalid_schedule_items
FROM tps_schedule_item
WHERE end_at <= start_at;
