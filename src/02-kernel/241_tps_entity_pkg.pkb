-- TPSDBCORE01 | CORE-03 | R1 | NOT DEPLOYED
CREATE OR REPLACE PACKAGE BODY tps_entity_pkg AS
  FUNCTION ensure_entity(
    p_type_code       IN VARCHAR2,
    p_canonical_key   IN VARCHAR2,
    p_canonical_name  IN VARCHAR2,
    p_attributes_json IN JSON DEFAULT NULL
  ) RETURN NUMBER IS
    l_type_id NUMBER;
    l_entity_id NUMBER;
  BEGIN
    SELECT entity_type_id INTO l_type_id
    FROM tps_entity_type
    WHERE type_code=UPPER(TRIM(p_type_code)) AND lifecycle_state='ACTIVE';

    BEGIN
      SELECT entity_id INTO l_entity_id
      FROM tps_entity
      WHERE canonical_key=UPPER(TRIM(p_canonical_key));

      UPDATE tps_entity
         SET canonical_name=p_canonical_name,
             attributes_json=COALESCE(p_attributes_json,attributes_json),
             updated_at=SYSTIMESTAMP,
             updated_by=SYS_CONTEXT('USERENV','SESSION_USER'),
             row_version=row_version+1
       WHERE entity_id=l_entity_id
         AND entity_type_id=l_type_id
         AND state='ACTIVE';
      IF SQL%ROWCOUNT<>1 THEN
        RAISE_APPLICATION_ERROR(-20101,'ENTITY_KEY_EXISTS_WITH_INCOMPATIBLE_TYPE_OR_STATE');
      END IF;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        INSERT INTO tps_entity(entity_type_id,canonical_key,canonical_name,attributes_json)
        VALUES(l_type_id,UPPER(TRIM(p_canonical_key)),p_canonical_name,p_attributes_json)
        RETURNING entity_id INTO l_entity_id;
    END;
    RETURN l_entity_id;
  END;

  PROCEDURE retire_entity(
    p_entity_id        IN NUMBER,
    p_superseded_by_id IN NUMBER DEFAULT NULL,
    p_effective_at     IN TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP
  ) IS
  BEGIN
    IF p_superseded_by_id=p_entity_id THEN
      RAISE_APPLICATION_ERROR(-20102,'ENTITY_CANNOT_SUPERSEDE_ITSELF');
    END IF;
    UPDATE tps_entity
       SET state=CASE WHEN p_superseded_by_id IS NULL THEN 'RETIRED' ELSE 'SUPERSEDED' END,
           superseded_by_id=p_superseded_by_id,
           valid_to=p_effective_at,
           updated_at=SYSTIMESTAMP,
           updated_by=SYS_CONTEXT('USERENV','SESSION_USER'),
           row_version=row_version+1
     WHERE entity_id=p_entity_id
       AND state='ACTIVE'
       AND p_effective_at>valid_from;
    IF SQL%ROWCOUNT<>1 THEN
      RAISE_APPLICATION_ERROR(-20103,'ACTIVE_ENTITY_NOT_FOUND_OR_INVALID_EFFECTIVE_TIME');
    END IF;
  END;
END tps_entity_pkg;
/
