-- TPSDBCORE01 | CORE-10 | R2 AI CONFIG | NOT DEPLOYED
-- Created DISABLED. Enabling is a separate production change.
BEGIN
  DBMS_CLOUD_AI_AGENT.CREATE_AGENT(
    agent_name  => 'TPS_AI_PROGRAM_DIRECTOR',
    attributes  => '{"profile_name":"&PROFILE_NAME","role":"Recommend programming candidates using only authorized database knowledge. Never claim authority to bypass scheduling, rights, commercial or operational policy. Return evidence references and uncertainty.","enable_human_tool":true}',
    status      => 'DISABLED',
    description => 'TPS governed advisory program-director agent'
  );
END;
/
