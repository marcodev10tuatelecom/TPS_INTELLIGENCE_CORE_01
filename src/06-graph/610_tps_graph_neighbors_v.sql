/*=============================================================================
 @file              src/06-graph/610_tps_graph_neighbors_v.sql
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-05/15
 @workstream        WS-06 Property Graph / WS-19 Validation
 @source_state      SOURCE_READY_WITH_LIMITATION
 @production_state  NOT_DEPLOYED
 @reversibility     R1_ADDITIVE
 @purpose           Expose one-hop directed graph neighbors as a relational view using
                    Oracle GRAPH_TABLE over TPS_MEDIA_KNOWLEDGE_GRAPH.
 @business_impact   Provides a reusable graph-neighborhood primitive for relationship lookup,
                    Graph RAG, diagnostics and application/API projections.
 @objects           Creates/replaces TPS_GRAPH_NEIGHBORS_V.
 @dependencies      TPS_MEDIA_KNOWLEDGE_GRAPH and its entity/relation labels/properties.
 @upstream          Property graph projected from TPS_ENTITY/TPS_RELATION.
 @downstream        Graph RAG source, graph tests, APIs/analytics and performance benchmarks.
 @d3ka_role         GRAPH/RELATION
 @d3ka_links        Traverses S --R--> T and returns S/T keys plus relation/context/confidence metadata.
 @ai_role           Candidate retrieval primitive for Graph RAG. Results still require temporal,
                    provenance, verification, policy and security filtering as appropriate.
 @security          Exposes graph relationship metadata; not a security filter by itself.
 @performance       One-hop GRAPH_TABLE pattern. At scale, latency/cardinality require CORE-17
                    benchmarks and predicates should be pushed from consumers where possible.
 @transaction       Read-only view; no data mutation.
 @idempotency       CREATE OR REPLACE VIEW repeatable when graph is valid.
 @failure_modes     Missing/invalid graph, incompatible GRAPH_TABLE syntax/labels, privilege issues.
                    IMPORTANT: filter is only r.state='ACTIVE'; it does NOT evaluate VALID_FROM/
                    VALID_TO against SYSTIMESTAMP. Therefore the view means active-lifecycle edges,
                    not necessarily edges valid at the current instant. Graph RAG requiring current
                    truth must add temporal filtering or use a future temporal graph projection.
 @rollback_recovery Drop/recreate view; graph/base relational data unaffected.
 @tests             tests/graph/G-001..003; PERF-004_graph_neighborhood.sql;
                    temporal equivalence tests are still required for current-valid graph retrieval.
 @evidence          CORE-05 graph query evidence; CORE-15 relational equivalence; CORE-17 performance.
 @references        Oracle AI Database 26ai Property Graph GRAPH_TABLE/SQL-PGQ documentation.
 @links             src/06-graph/600_tps_media_knowledge_graph.sql;
                    src/05-temporal/500_tps_relation_current_v.sql;
                    src/11-ai/1140_graph_rag_neighbors.sql
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.02 2026-09-01 — full docs and temporal limitation; query unchanged.
=============================================================================*/

-- One-hop directed active-lifecycle graph projection. Not equivalent to "valid now".
CREATE OR REPLACE VIEW tps_graph_neighbors_v AS
SELECT *
FROM GRAPH_TABLE (
  tps_media_knowledge_graph
  MATCH (s IS entity)-[r IS relation]->(t IS entity)
  WHERE r.state = 'ACTIVE'
  COLUMNS (
    s.entity_id AS source_entity_id,
    s.canonical_key AS source_key,
    r.relation_id AS relation_id,
    r.relation_type_id AS relation_type_id,
    r.context_id AS context_id,
    r.confidence AS confidence,
    t.entity_id AS target_entity_id,
    t.canonical_key AS target_key
  )
);
