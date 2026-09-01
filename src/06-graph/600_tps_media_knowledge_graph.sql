-- TPSDBCORE01 | CORE-05 | R1 ADDITIVE | NOT DEPLOYED
-- Oracle AI Database 26ai CREATE PROPERTY GRAPH; only graph-safe scalar columns are exposed.
CREATE PROPERTY GRAPH tps_media_knowledge_graph
    VERTEX TABLES (
        tps_entity AS entity
            KEY (entity_id)
            LABEL entity
            PROPERTIES (
                entity_type_id,
                canonical_key,
                canonical_name,
                state,
                valid_from,
                valid_to,
                created_at,
                updated_at
            )
    )
    EDGE TABLES (
        tps_relation AS relation
            KEY (relation_id)
            SOURCE KEY (source_entity_id) REFERENCES entity(entity_id)
            DESTINATION KEY (target_entity_id) REFERENCES entity(entity_id)
            LABEL relation
            PROPERTIES (
                relation_type_id,
                context_id,
                provenance_source_id,
                weight,
                confidence,
                state,
                assertion_class,
                valid_from,
                valid_to,
                observed_at,
                recorded_at,
                created_at
            )
    );
