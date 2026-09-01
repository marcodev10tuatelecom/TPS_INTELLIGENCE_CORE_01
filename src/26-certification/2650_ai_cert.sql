-- CORE-10/16 AI CERTIFICATION | R0
SELECT state,authority_class,COUNT(*) agent_count
FROM tps_ai_agent
GROUP BY state,authority_class
ORDER BY state,authority_class;

SELECT policy_result,final_action,human_override,COUNT(*)
FROM tps_ai_decision
GROUP BY policy_result,final_action,human_override
ORDER BY policy_result,final_action,human_override;
