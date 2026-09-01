-- TPSDBCORE01 | CORE-14 PROGRAMMING AUTHORITY | R1 | NOT DEPLOYED
CREATE OR REPLACE PACKAGE BODY tps_schedule_pkg AS
  FUNCTION resolve_current_item(
    p_channel_entity_id IN NUMBER,
    p_at                IN TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP
  ) RETURN NUMBER IS
    l_item_id NUMBER;
  BEGIN
    -- Owner chain follows active BELONGS_TO from channel -> station -> network.
    WITH owner_chain(entity_id,depth) AS (
      SELECT p_channel_entity_id,0 FROM dual
      UNION ALL
      SELECT r.target_entity_id,oc.depth+1
      FROM owner_chain oc
      JOIN tps_relation r ON r.source_entity_id=oc.entity_id
      JOIN tps_relation_type rt ON rt.relation_type_id=r.relation_type_id
      WHERE rt.relation_code='BELONGS_TO'
        AND r.state='ACTIVE'
        AND r.valid_from<=p_at
        AND (r.valid_to IS NULL OR p_at<r.valid_to)
        AND oc.depth<8
    ), candidates AS (
      SELECT si.schedule_item_id,
             CASE s.schedule_class
               WHEN 'EMERGENCY' THEN 1
               WHEN 'LOCAL_OVERRIDE' THEN 10
               WHEN 'CHANNEL' THEN 20
               WHEN 'STATION' THEN 30
               WHEN 'NETWORK' THEN 40
               WHEN 'FALLBACK' THEN 90
               ELSE 50 END AS class_rank,
             s.precedence,
             oc.depth,
             si.priority
      FROM owner_chain oc
      JOIN tps_schedule s ON s.owner_entity_id=oc.entity_id
      JOIN tps_schedule_item si ON si.schedule_id=s.schedule_id
      WHERE s.state='ACTIVE'
        AND si.state='ACTIVE'
        AND s.valid_from<=p_at
        AND (s.valid_to IS NULL OR p_at<s.valid_to)
        AND si.start_at<=p_at
        AND p_at<si.end_at
    )
    SELECT schedule_item_id INTO l_item_id
    FROM candidates
    ORDER BY class_rank,precedence,depth,priority,schedule_item_id
    FETCH FIRST 1 ROW ONLY;
    RETURN l_item_id;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN RETURN NULL;
  END;

  FUNCTION has_fallback(
    p_owner_entity_id IN NUMBER,
    p_at              IN TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP
  ) RETURN NUMBER IS
    l_count NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_count
    FROM tps_schedule s
    JOIN tps_schedule_item si ON si.schedule_id=s.schedule_id
    WHERE s.owner_entity_id=p_owner_entity_id
      AND s.schedule_class='FALLBACK'
      AND s.state='ACTIVE'
      AND si.state='ACTIVE'
      AND s.valid_from<=p_at
      AND (s.valid_to IS NULL OR p_at<s.valid_to)
      AND si.start_at<=p_at
      AND p_at<si.end_at;
    RETURN CASE WHEN l_count>0 THEN 1 ELSE 0 END;
  END;
END tps_schedule_pkg;
/
