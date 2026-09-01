-- TPSDBCORE01 | CORE-14 CONTINUITY CERTIFICATION | R0
SELECT COUNT(*) AS schedule_gap_count FROM tps_schedule_gap_v;
SELECT COUNT(*) AS schedule_overlap_count FROM tps_schedule_overlap_v;

SELECT c.channel_entity_id
FROM tps_channel c
WHERE c.operational_state='ACTIVE'
  AND tps_schedule_pkg.resolve_current_item(c.channel_entity_id,SYSTIMESTAMP) IS NULL
ORDER BY c.channel_entity_id;
