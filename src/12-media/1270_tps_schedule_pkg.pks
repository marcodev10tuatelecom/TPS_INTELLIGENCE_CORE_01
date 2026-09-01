-- TPSDBCORE01 | CORE-14 PROGRAMMING AUTHORITY | R1 | NOT DEPLOYED
CREATE OR REPLACE PACKAGE tps_schedule_pkg AUTHID DEFINER AS
  FUNCTION resolve_current_item(
    p_channel_entity_id IN NUMBER,
    p_at                IN TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP
  ) RETURN NUMBER;

  FUNCTION has_fallback(
    p_owner_entity_id IN NUMBER,
    p_at              IN TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP
  ) RETURN NUMBER;
END tps_schedule_pkg;
/
