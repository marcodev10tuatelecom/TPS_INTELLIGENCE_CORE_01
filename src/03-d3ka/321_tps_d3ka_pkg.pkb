-- TPSDBCORE01 | CORE-04/06/07/09/11 | R1 | NOT DEPLOYED
CREATE OR REPLACE PACKAGE BODY tps_d3ka_pkg AS
    FUNCTION relation_type_id(p_code IN VARCHAR2) RETURN NUMBER IS
        l_id NUMBER;
    BEGIN
        SELECT relation_type_id INTO l_id
        FROM tps_relation_type
        WHERE relation_code = UPPER(TRIM(p_code))
          AND lifecycle_state = 'ACTIVE';
        RETURN l_id;
    END;

    FUNCTION assert_relation(
        p_source_entity_id     IN NUMBER,
        p_relation_code        IN VARCHAR2,
        p_target_entity_id     IN NUMBER,
        p_context_id           IN NUMBER DEFAULT NULL,
        p_provenance_source_id IN NUMBER DEFAULT NULL,
        p_confidence           IN NUMBER DEFAULT NULL,
        p_assertion_class      IN VARCHAR2 DEFAULT 'FACT',
        p_valid_from           IN TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP,
        p_observed_at          IN TIMESTAMP WITH TIME ZONE DEFAULT NULL
    ) RETURN NUMBER IS
        l_type_id NUMBER;
        l_source_type NUMBER;
        l_target_type NUMBER;
        l_expected_source NUMBER;
        l_expected_target NUMBER;
        l_allow_self NUMBER;
        l_requires_context NUMBER;
        l_requires_provenance NUMBER;
        l_policy_sensitive NUMBER;
        l_relation_id NUMBER;
    BEGIN
        l_type_id := relation_type_id(p_relation_code);
        SELECT source_entity_type_id, target_entity_type_id, allow_self,
               requires_context, requires_provenance, policy_sensitive
          INTO l_expected_source, l_expected_target, l_allow_self,
               l_requires_context, l_requires_provenance, l_policy_sensitive
          FROM tps_relation_type WHERE relation_type_id = l_type_id;

        SELECT entity_type_id INTO l_source_type
        FROM tps_entity WHERE entity_id = p_source_entity_id AND state = 'ACTIVE';
        SELECT entity_type_id INTO l_target_type
        FROM tps_entity WHERE entity_id = p_target_entity_id AND state = 'ACTIVE';

        IF l_policy_sensitive = 1 THEN
            RAISE_APPLICATION_ERROR(-20000, 'D3KA_POLICY_SENSITIVE_RELATION_REQUIRES_SPECIALIZED_API');
        END IF;
        IF l_allow_self = 0 AND p_source_entity_id = p_target_entity_id THEN
            RAISE_APPLICATION_ERROR(-20001, 'D3KA_SELF_RELATION_NOT_ALLOWED');
        END IF;
        IF l_expected_source IS NOT NULL AND l_expected_source <> l_source_type THEN
            RAISE_APPLICATION_ERROR(-20002, 'D3KA_INVALID_SOURCE_TYPE');
        END IF;
        IF l_expected_target IS NOT NULL AND l_expected_target <> l_target_type THEN
            RAISE_APPLICATION_ERROR(-20003, 'D3KA_INVALID_TARGET_TYPE');
        END IF;
        IF l_requires_context = 1 AND p_context_id IS NULL THEN
            RAISE_APPLICATION_ERROR(-20004, 'D3KA_CONTEXT_REQUIRED');
        END IF;
        IF l_requires_provenance = 1 AND p_provenance_source_id IS NULL THEN
            RAISE_APPLICATION_ERROR(-20005, 'D3KA_PROVENANCE_REQUIRED');
        END IF;
        IF p_confidence IS NOT NULL AND (p_confidence < 0 OR p_confidence > 1) THEN
            RAISE_APPLICATION_ERROR(-20006, 'D3KA_CONFIDENCE_OUT_OF_RANGE');
        END IF;
        IF UPPER(p_assertion_class) IN ('INFERENCE','AI_INFERENCE','EXTERNAL_IMPORT')
           AND p_provenance_source_id IS NULL THEN
            RAISE_APPLICATION_ERROR(-20008, 'D3KA_ASSERTION_CLASS_REQUIRES_PROVENANCE');
        END IF;

        INSERT INTO tps_relation(
            source_entity_id, relation_type_id, target_entity_id, context_id,
            provenance_source_id, confidence, assertion_class, valid_from, observed_at
        ) VALUES (
            p_source_entity_id, l_type_id, p_target_entity_id, p_context_id,
            p_provenance_source_id, p_confidence, UPPER(p_assertion_class), p_valid_from, p_observed_at
        ) RETURNING relation_id INTO l_relation_id;
        RETURN l_relation_id;
    END;

    PROCEDURE end_relation(
        p_relation_id IN NUMBER,
        p_valid_to    IN TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP
    ) IS
    BEGIN
        UPDATE tps_relation
           SET valid_to = p_valid_to,
               state = 'INACTIVE'
         WHERE relation_id = p_relation_id
           AND state = 'ACTIVE'
           AND valid_to IS NULL
           AND p_valid_to > valid_from;
        IF SQL%ROWCOUNT <> 1 THEN
            RAISE_APPLICATION_ERROR(-20007, 'D3KA_ACTIVE_RELATION_NOT_FOUND_OR_INVALID_END_TIME');
        END IF;
    END;

    FUNCTION active_relation_count(
        p_source_entity_id IN NUMBER,
        p_relation_code    IN VARCHAR2,
        p_target_entity_id IN NUMBER DEFAULT NULL
    ) RETURN NUMBER IS
        l_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO l_count
        FROM tps_relation r
        JOIN tps_relation_type rt ON rt.relation_type_id = r.relation_type_id
        WHERE r.source_entity_id = p_source_entity_id
          AND rt.relation_code = UPPER(TRIM(p_relation_code))
          AND (p_target_entity_id IS NULL OR r.target_entity_id = p_target_entity_id)
          AND r.state = 'ACTIVE'
          AND r.valid_to IS NULL;
        RETURN l_count;
    END;
END tps_d3ka_pkg;
/
