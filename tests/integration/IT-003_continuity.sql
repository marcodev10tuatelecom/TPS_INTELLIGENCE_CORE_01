-- IT-003 | operational channels should resolve current content during certified coverage window
SELECT c.channel_entity_id
FROM tps_channel c
WHERE c.operational_state='ACTIVE'
  AND tps_schedule_pkg.resolve_current_item(c.channel_entity_id,:as_of_time) IS NULL
ORDER BY c.channel_entity_id;
