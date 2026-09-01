-- TPSDBCORE01 | CORE-11 | R1 | NOT DEPLOYED
CREATE OR REPLACE PACKAGE BODY tps_policy_engine_pkg AS
  FUNCTION authorize_content_action(
    p_content_entity_id IN NUMBER,
    p_beneficiary_entity_id IN NUMBER,
    p_action_code IN VARCHAR2,
    p_at IN TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP
  ) RETURN VARCHAR2 IS
    l_rights VARCHAR2(20);
  BEGIN
    l_rights := tps_rights_pkg.decision_for(p_content_entity_id,p_beneficiary_entity_id,p_action_code,p_at);
    IF l_rights='DENY' THEN RETURN 'DENY_RIGHTS'; END IF;
    IF l_rights='UNKNOWN' THEN RETURN 'DENY_UNKNOWN_RIGHTS'; END IF;
    RETURN 'ALLOW';
  END;
END tps_policy_engine_pkg;
/
