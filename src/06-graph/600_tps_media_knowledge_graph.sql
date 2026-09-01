/*=============================================================================
 @file              src/06-graph/600_tps_media_knowledge_graph.sql
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-05
 @workstream        WS-06 Property Knowledge Graph
 @source_state      SOURCE_READY_PENDING_RUNTIME_COMPATIBILITY_TEST
 @production_state  NOT_DEPLOYED
 @reversibility     R1_ADDITIVE
 @purpose           Define the canonical Oracle Property Graph projection in which
                    TPS_ENTITY rows are vertices and TPS_RELATION rows are directed edges,
                    preserving one relational authority while enabling graph traversal.
 @business_impact   Enables unified relationship exploration across networks, stations,
                    programming, media, rights, advertisers, audience, editorial and AI
                    without duplicating data into a separate graph database.
 @objects           Creates PROPERTY GRAPH TPS_MEDIA_KNOWLEDGE_GRAPH.
 @dependencies      TPS_ENTITY and TPS_RELATION; Oracle AI Database 26ai Property Graph syntax/capability.
 @upstream          Universal identity and D3KA relation kernel.
 @downstream        GRAPH_TABLE queries, TPS_GRAPH_NEIGHBORS_V, Graph RAG, graph algorithms,
                    validation and AI/analytics consumers.
 @d3ka_role         GRAPH/ENTITY/RELATION
 @d3ka_links        Vertex key = D3KA endpoint ENTITY_ID. Edge key = RELATION_ID with S and T
                    endpoint references. Edge properties expose C/Tv/To/E/Q/P metadata stored
                    in TPS_RELATION because PROPERTIES ARE ALL COLUMNS.
 @ai_role           Foundation for Graph RAG and graph-aware agents. Graph data remains subject
                    to assertion/provenance/security/temporal/policy constraints before AI use.
 @security          PROPERTIES ARE ALL COLUMNS exposes all table columns to graph queries available
                    to graph users. Grants and data classification must be reviewed before deployment;
                    graph access must not bypass relational security intent.
 @performance       Graph projection does not eliminate underlying relational cardinality/cost.
                    Traversal performance, edge selectivity and graph memory/service behavior require
                    CORE-17 tests on real scale. Property graph creation/refresh semantics must be
                    verified against the installed 26ai Autonomous service.
 @transaction       DDL operation with Oracle implicit commit when deployed; no business DML.
 @idempotency       CREATE PROPERTY GRAPH is not inherently idempotent. Deployment requires precheck.
 @failure_modes     Unsupported/changed syntax, insufficient privileges, invalid endpoint references,
                    object already exists or source-table incompatibility. Source alignment with Oracle
                    26ai documentation is not runtime proof; CORE-01/05 compatibility test remains required.
 @rollback_recovery Drop property graph only; underlying TPS_ENTITY/TPS_RELATION relational authority
                    must remain untouched. Recreate previous graph definition if rollback needed.
 @tests             tests/graph/G-001_graph_smoke.sql; G-002_graph_relational_equivalence.sql;
                    G-003_graph_relation_integrity.sql; PERF-004_graph_neighborhood.sql.
 @evidence          CORE-05 graph creation/query evidence; CORE-15 graph equivalence/integrity;
                    CORE-17 performance; CORE-18 security; CORE-20 certification.
 @references        Oracle AI Database 26ai Property Graph documentation and SQL Language Reference,
                    including CREATE PROPERTY GRAPH / GRAPH_TABLE / SQL-PGQ capabilities.
 @links             src/02-kernel/210_tps_entity.sql; src/03-d3ka/310_tps_relation.sql;
                    src/06-graph/610_tps_graph_neighbors_v.sql;
                    docs/04-d3ka/D3KA-ENGINEERING-SPEC-v0.02.md
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.02 2026-09-01 — full embedded documentation; graph DDL unchanged.
=============================================================================*/

-- Graph is a projection of the relational authority, not a second persisted truth model.
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
