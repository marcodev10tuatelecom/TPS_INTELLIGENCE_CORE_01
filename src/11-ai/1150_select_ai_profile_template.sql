-- TPSDBCORE01 | CORE-10 | R2 AI CONFIG | NOT DEPLOYED
-- Requires approved provider credential outside Git and CORE-10 change record.
-- SQLcl/SQL*Plus substitution variables are intentional.
BEGIN
  DBMS_CLOUD_AI.CREATE_PROFILE(
    profile_name => '&PROFILE_NAME',
    attributes   => '{"provider":"&PROVIDER_CODE","credential_name":"&CREDENTIAL_NAME","object_list":[{"owner":"&OBJECT_OWNER","name":"TPS_D3KA_ACTIVE_V"},{"owner":"&OBJECT_OWNER","name":"TPS_GRAPH_NEIGHBORS_V"}]}'
  );
END;
/
