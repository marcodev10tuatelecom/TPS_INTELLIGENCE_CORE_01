-- TPSDBCORE01 | CORE-05 | R1 ADDITIVE | NOT DEPLOYED
-- Syntax aligned with Oracle AI Database 26ai CREATE PROPERTY GRAPH.
CREATE PROPERTY GRAPH tps_media_knowledge_graph
    VERTEX TABLES (
        tps_entity AS entity
            KEY (entity_id)
            LABEL entity
            PROPERTIES ARE ALL COLUMNS
    )
    EDGE TABLES (
        tps_relation AS relation
            KEY (relation_id)
            SOURCE KEY (source_entity_id) REFERENCES entity(entity_id)
            DESTINATION KEY (target_entity_id) REFERENCES entity(entity_id)
            LABEL relation
            PROPERTIES ARE ALL COLUMNS
    );
