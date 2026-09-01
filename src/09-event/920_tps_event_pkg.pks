-- TPSDBCORE01 | EVENT FABRIC | R1 | NOT DEPLOYED
CREATE OR REPLACE PACKAGE tps_event_pkg AUTHID DEFINER AS
  FUNCTION append_event(
    p_event_code        IN VARCHAR2,
    p_event_time        IN TIMESTAMP WITH TIME ZONE,
    p_subject_entity_id IN NUMBER DEFAULT NULL,
    p_context_id        IN NUMBER DEFAULT NULL,
    p_source_id         IN NUMBER DEFAULT NULL,
    p_correlation_id    IN VARCHAR2 DEFAULT NULL,
    p_payload_json      IN JSON DEFAULT NULL
  ) RETURN NUMBER;
END tps_event_pkg;
/
