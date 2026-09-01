-- TPSDBCORE01 | CORE-10 | R2 AI CONFIG | NOT DEPLOYED
BEGIN
  DBMS_CLOUD_AI_AGENT.CREATE_TOOL(
    tool_name  => 'TPS_MEDIA_SQL_TOOL',
    attributes => '{"tool_type":"SQL","tool_params":{"profile_name":"&PROFILE_NAME"},"instruction":"Query only the objects exposed by the approved AI profile. Do not perform DDL or DML."}',
    status      => 'DISABLED',
    description => 'Read-oriented Select AI SQL tool for approved media objects'
  );
END;
/
