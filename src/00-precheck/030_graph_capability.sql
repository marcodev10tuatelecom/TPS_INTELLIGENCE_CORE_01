/*=============================================================================
 @file              src/00-precheck/030_graph_capability.sql
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-01/05
 @workstream        WS-03 Oracle capability / WS-06 Property Knowledge Graph
 @source_state      SOURCE_READY
 @production_state  READ_ONLY_NOT_DEPLOYED
 @reversibility     READ_ONLY
 @purpose           Discover visible Property Graph-related objects and dictionary views
                    without creating a graph, proving only what the connected production
                    database exposes to the current session.
 @business_impact   Protects the D3KA graph-first architecture from being implemented on an
                    unverified assumption about SQL/PGQ/Property Graph capability.
 @objects           Reads ALL_OBJECTS and ALL_VIEWS only; creates no property graph.
 @dependencies      Dictionary visibility privileges.
 @upstream          CORE-00 identity, feature inventory.
 @downstream        CORE-01 feature matrix; design/deployment of TPS_MEDIA_KNOWLEDGE_GRAPH.
 @d3ka_role         GRAPH
 @d3ka_links        Property Graph is the principal traversal representation of sparse D3KA
                    S/R/T relationships backed by TPS_ENTITY/TPS_RELATION.
 @ai_role           Graph capability enables future Graph RAG/agent retrieval; no AI call occurs here.
 @security          Dictionary metadata only; no business graph or data is queried.
 @performance       Small metadata queries; no production graph workload.
 @transaction       SELECT only; no mutation/commit/locks.
 @idempotency       Repeatable. Results may change after Oracle service upgrades/privilege changes.
 @failure_modes     Empty result means graph capability is not proven by this probe; it does not
                    conclusively prove absence. Dictionary naming/visibility may vary by release.
                    CORE-01 requires documentation + controlled compatibility tests before PASS.
 @rollback_recovery None; read-only.
 @tests             tests/graph/G-001_graph_smoke.sql is a later graph-object test and must not
                    be run until the graph source is deployed under an approved gate.
 @evidence          CORE-01 graph capability discovery and CORE-05 readiness decision.
 @references        Oracle AI Database 26ai Property Graph documentation; SQL/PGQ SQL:2023
                    support documentation for the installed release.
 @links             src/00-precheck/010_feature_inventory.sql;
                    src/06-graph/600_tps_media_knowledge_graph.sql;
                    docs/04-d3ka/D3KA-ENGINEERING-SPEC-v0.02.md
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.02 2026-09-01 — full embedded documentation; queries unchanged.
=============================================================================*/

-- Dictionary discovery only; no property graph is created or modified.
SELECT owner, object_name, object_type, status
FROM all_objects
WHERE object_type LIKE '%PROPERTY GRAPH%'
   OR object_name IN ('DBMS_GAF','DBMS_OGA')
ORDER BY owner, object_name;

-- Visibility count is evidence input only, not a binary feature guarantee.
SELECT COUNT(*) AS graph_dictionary_views_visible
FROM all_views
WHERE view_name LIKE '%PROPERTY_GRAPH%';
