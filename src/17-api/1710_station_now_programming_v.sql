-- TPSDBCORE01 | CORE-13/14 | R1 VIEW | NOT DEPLOYED
CREATE OR REPLACE VIEW tps_station_now_programming_v AS
SELECT s.owner_entity_id,
       si.schedule_item_id,
       si.content_entity_id,
       si.start_at,
       si.end_at,
       si.item_class,
       s.precedence,
       s.schedule_class
FROM tps_schedule s
JOIN tps_schedule_item si ON si.schedule_id=s.schedule_id
WHERE s.state='ACTIVE'
  AND si.state='ACTIVE'
  AND SYSTIMESTAMP >= si.start_at
  AND SYSTIMESTAMP < si.end_at;
