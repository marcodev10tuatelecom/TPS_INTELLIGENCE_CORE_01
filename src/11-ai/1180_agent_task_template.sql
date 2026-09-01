-- TPSDBCORE01 | CORE-10 | R2 AI CONFIG | NOT DEPLOYED
BEGIN
  DBMS_CLOUD_AI_AGENT.CREATE_TASK(
    task_name  => 'TPS_RECOMMEND_PROGRAMMING_TASK',
    attributes => '{"instruction":"For {query}, retrieve only approved evidence, propose ranked programming candidates, state constraints and uncertainty, and do not authorize execution.","tools":["TPS_MEDIA_SQL_TOOL"],"enable_human_tool":true}',
    status      => 'DISABLED',
    description => 'Advisory programming recommendation task'
  );
END;
/
