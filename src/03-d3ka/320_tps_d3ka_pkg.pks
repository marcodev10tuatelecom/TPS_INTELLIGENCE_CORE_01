-- TPSDBCORE01 | CORE-04/06/07/09 | R1 | NOT DEPLOYED
CREATE OR REPLACE PACKAGE tps_d3ka_pkg AUTHID DEFINER AS
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
    ) RETURN NUMBER;

    PROCEDURE end_relation(
        p_relation_id IN NUMBER,
        p_valid_to    IN TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP
    );

    FUNCTION active_relation_count(
        p_source_entity_id IN NUMBER,
        p_relation_code    IN VARCHAR2,
        p_target_entity_id IN NUMBER DEFAULT NULL
    ) RETURN NUMBER;
END tps_d3ka_pkg;
/
