-- AI-001 | no unrestricted agent authority class | R0
SELECT COUNT(*) AS unsafe_agents
FROM tps_ai_agent
WHERE authority_class NOT IN ('ADVISORY','BOUNDED_AUTOMATION','ANALYTICS_ONLY');
