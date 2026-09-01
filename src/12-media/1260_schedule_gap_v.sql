-- TPSDBCORE01 | PROGRAMMING CONTINUITY | R1 VIEW / R0 USE | NOT DEPLOYED
CREATE OR REPLACE VIEW tps_schedule_gap_v AS
WITH ordered_items AS (
  SELECT schedule_id,
         schedule_item_id,
         start_at,
         end_at,
         LAG(end_at) OVER(PARTITION BY schedule_id ORDER BY start_at,end_at,schedule_item_id) AS previous_end_at
  FROM tps_schedule_item
  WHERE state='ACTIVE'
)
SELECT schedule_id,
       schedule_item_id,
       previous_end_at AS gap_from,
       start_at AS gap_to,
       (start_at-previous_end_at) AS gap_interval
FROM ordered_items
WHERE previous_end_at IS NOT NULL
  AND start_at>previous_end_at;
