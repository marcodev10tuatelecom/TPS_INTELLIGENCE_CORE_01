-- TPSDBCORE01 | RIGHTS DOMAIN | R1 | NOT DEPLOYED
CREATE OR REPLACE PACKAGE tps_rights_pkg AUTHID DEFINER AS
  FUNCTION decision_for(
    p_content_entity_id     IN NUMBER,
    p_beneficiary_entity_id IN NUMBER,
    p_action_code           IN VARCHAR2,
    p_at                    IN TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP
  ) RETURN VARCHAR2;
END tps_rights_pkg;
/
