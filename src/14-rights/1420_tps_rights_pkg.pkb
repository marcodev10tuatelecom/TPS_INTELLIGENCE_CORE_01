-- TPSDBCORE01 | RIGHTS DOMAIN | R1 | NOT DEPLOYED
CREATE OR REPLACE PACKAGE BODY tps_rights_pkg AS
  FUNCTION decision_for(
    p_content_entity_id IN NUMBER,
    p_beneficiary_entity_id IN NUMBER,
    p_action_code IN VARCHAR2,
    p_at IN TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP,
    p_territory_entity_id IN NUMBER DEFAULT NULL,
    p_context_id IN NUMBER DEFAULT NULL
  ) RETURN VARCHAR2 IS
    l_deny NUMBER;
    l_allow NUMBER;
  BEGIN
    SELECT SUM(CASE WHEN decision='DENY' THEN 1 ELSE 0 END),
           SUM(CASE WHEN decision='ALLOW' THEN 1 ELSE 0 END)
      INTO l_deny,l_allow
      FROM tps_right_grant
     WHERE content_entity_id=p_content_entity_id
       AND beneficiary_entity_id=p_beneficiary_entity_id
       AND action_code=UPPER(TRIM(p_action_code))
       AND state='ACTIVE'
       AND p_at>=valid_from AND p_at<valid_to
       AND (territory_entity_id IS NULL OR territory_entity_id=p_territory_entity_id)
       AND (context_id IS NULL OR context_id=p_context_id);
    IF NVL(l_deny,0)>0 THEN RETURN 'DENY'; END IF;
    IF NVL(l_allow,0)>0 THEN RETURN 'ALLOW'; END IF;
    RETURN 'UNKNOWN';
  END;
END tps_rights_pkg;
/
