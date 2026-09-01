-- IT-002 | rights decision includes territory/context | R0 against prepared fixture
SELECT tps_rights_pkg.decision_for(
  :content_entity_id,:beneficiary_entity_id,:action_code,:as_of_time,
  :territory_entity_id,:context_id
) AS decision
FROM dual;
