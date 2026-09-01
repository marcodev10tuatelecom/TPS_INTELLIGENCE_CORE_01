-- PERF-003 | current schedule and rights decision workload | R0
SELECT * FROM tps_station_now_programming_v
WHERE owner_entity_id=:station_or_channel_entity_id;

SELECT tps_rights_pkg.decision_for(
  :content_entity_id,:beneficiary_entity_id,:action_code,SYSTIMESTAMP
) AS rights_decision FROM dual;
