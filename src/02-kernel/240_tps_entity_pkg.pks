-- TPSDBCORE01 | CORE-03 | R1 | NOT DEPLOYED
CREATE OR REPLACE PACKAGE tps_entity_pkg AUTHID DEFINER AS
  FUNCTION ensure_entity(
    p_type_code       IN VARCHAR2,
    p_canonical_key   IN VARCHAR2,
    p_canonical_name  IN VARCHAR2,
    p_attributes_json IN JSON DEFAULT NULL
  ) RETURN NUMBER;

  PROCEDURE retire_entity(
    p_entity_id        IN NUMBER,
    p_superseded_by_id IN NUMBER DEFAULT NULL,
    p_effective_at     IN TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP
  );
END tps_entity_pkg;
/
