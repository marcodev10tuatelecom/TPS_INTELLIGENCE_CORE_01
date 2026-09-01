-- IT-001 | schedule resolver smoke | R0 against prepared fixture
SELECT tps_schedule_pkg.resolve_current_item(:channel_entity_id,:as_of_time) AS resolved_schedule_item_id
FROM dual;
