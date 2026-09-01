-- TPSDBCORE01 | PROGRAMMING CONTINUITY | R1 VIEW / R0 USE | NOT DEPLOYED
CREATE OR REPLACE VIEW tps_schedule_overlap_v AS
WITH ordered_items AS (
  SELECT schedule_id,
         schedule_item_id,
         start_at,
         end_at,
         LAG(schedule_item_id) OVER(PARTITION BY schedule_id ORDER BY start_at,end_at,schedule_item_id) AS previous_item_id,
         LAG(end_at) OVER(PARTITION BY schedule_id ORDER BY start_at,end_at,schedule_item_id) AS previous_end_at
  FROM tps_schedule_item
  WHERE state='ACTIVE'
)
SELECT schedule_id,
       previous_item_id,
       schedule_item_id,
       start_at AS overlap_from,
       LEAST(previous_end_at,end_at) AS overlap_to
FROM ordered_items
WHERE previous_end_at IS NOT NULL
  AND start_at<previous_end_at;
