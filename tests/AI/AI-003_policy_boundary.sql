-- AI-003 | policy remains independent of AI output | R0
-- Unknown rights are expected to fail closed as DENY_UNKNOWN_RIGHTS.
SELECT tps_policy_engine_pkg.authorize_content_action(
         :content_entity_id,
         :beneficiary_entity_id,
         :action_code,
         SYSTIMESTAMP
       ) AS policy_decision
FROM dual;
