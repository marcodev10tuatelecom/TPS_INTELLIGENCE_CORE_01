-- TPSDBCORE01 | EVENT FABRIC | R1 | NOT DEPLOYED
CREATE OR REPLACE PACKAGE BODY tps_event_pkg AS
  FUNCTION append_event(
    p_event_code        IN VARCHAR2,
    p_event_time        IN TIMESTAMP WITH TIME ZONE,
    p_subject_entity_id IN NUMBER DEFAULT NULL,
    p_context_id        IN NUMBER DEFAULT NULL,
    p_source_id         IN NUMBER DEFAULT NULL,
    p_correlation_id    IN VARCHAR2 DEFAULT NULL,
    p_payload_json      IN JSON DEFAULT NULL
  ) RETURN NUMBER IS
    l_type_id NUMBER;
    l_event_id NUMBER;
  BEGIN
    IF p_event_time IS NULL THEN
      RAISE_APPLICATION_ERROR(-20201,'EVENT_TIME_REQUIRED');
    END IF;
    SELECT event_type_id INTO l_type_id
    FROM tps_event_type
    WHERE event_code=UPPER(TRIM(p_event_code));

    INSERT INTO tps_event(
      event_type_id,subject_entity_id,context_id,source_id,
      correlation_id,event_time,payload_json
    ) VALUES(
      l_type_id,p_subject_entity_id,p_context_id,p_source_id,
      p_correlation_id,p_event_time,p_payload_json
    ) RETURNING event_id INTO l_event_id;
    RETURN l_event_id;
  END;
END tps_event_pkg;
/
