/*=============================================================================
 @file              src/00-precheck/050_json_duality_capability.sql
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-01/13
 @workstream        WS-03 Oracle capability / WS-17 API/read models
 @source_state      SOURCE_READY
 @production_state  READ_ONLY_NOT_DEPLOYED
 @reversibility     READ_ONLY
 @purpose           Discover visible JSON Relational Duality metadata and prove basic JSON
                    SQL expression support without creating a duality view or persistent data.
 @business_impact   Supports the architecture in which applications consume JSON projections
                    of one relational authority rather than maintaining duplicated application databases.
 @objects           Reads ALL_OBJECTS and evaluates JSON_OBJECT from DUAL only.
 @dependencies      Oracle JSON SQL support and dictionary visibility.
 @upstream          CORE-00 identity and feature inventory.
 @downstream        CORE-13 JSON Duality/API projection design.
 @d3ka_role         NONE directly; exposes D3KA/relational knowledge as API-friendly JSON read models.
 @d3ka_links        Future duality views can project entity/relationship state without becoming a second truth.
 @ai_role           JSON read models may support tools/agents but this source invokes no AI.
 @security          No business data or credentials. Future duality views require row/column/API authorization.
 @performance       Small metadata query plus one literal JSON expression.
 @transaction       SELECT only; no DDL/DML/commit/lock.
 @idempotency       Fully repeatable.
 @failure_modes     No visible duality objects may simply mean none are created yet; therefore the metadata
                    query alone does not prove CREATE JSON RELATIONAL DUALITY VIEW syntax/privilege.
                    JSON_OBJECT success proves only basic JSON SQL expression capability.
 @rollback_recovery None; read-only.
 @tests             Later CORE-13 duality-view compilation/query tests after approved deployment.
 @evidence          CORE-01 JSON capability evidence and CORE-13 design gate.
 @references        Oracle AI Database 26ai JSON-Relational Duality Views documentation and SQL Language Reference.
 @links             src/17-api/1720_entity_duality_view.sql;
                    docs/03-architecture/MASTER-DATABASE-ENGINEERING-SPEC-v0.02.md
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.02 2026-09-01 — full embedded documentation; queries unchanged.
=============================================================================*/

-- Existing/visible duality-related objects only; absence does not prove feature absence.
SELECT owner, object_name, object_type, status
FROM all_objects
WHERE object_type LIKE '%DUALITY%'
ORDER BY owner, object_name;

-- Basic JSON SQL expression probe. The result is transient and no object/data is persisted.
SELECT JSON_OBJECT('probe' VALUE 'TPSDBCORE01') AS json_probe FROM dual;
