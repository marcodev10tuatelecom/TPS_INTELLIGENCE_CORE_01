/*=============================================================================
 @file              src/00-precheck/010_feature_inventory.sql
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-01
 @workstream        WS-03 Oracle capability engineering
 @source_state      SOURCE_READY
 @production_state  READ_ONLY_NOT_DEPLOYED
 @reversibility     READ_ONLY
 @purpose           Inventory visible Oracle options and AI/vector/graph-related packages
                    before designing or deploying feature-dependent database objects.
 @business_impact   Prevents architecture from assuming a feature/package is usable merely
                    because it exists in documentation or OCI UI; compatibility must be
                    proven inside the connected production database.
 @objects           Reads V$OPTION and ALL_OBJECTS; creates/modifies nothing.
 @dependencies      Dictionary visibility privileges for V$OPTION/ALL_OBJECTS.
 @upstream          Connected TPSDBCORE01 session established by 000_database_identity.sql.
 @downstream        CORE-01 feature matrix and design decisions for Spatial, Text, Graph,
                    ML, DBMS_CLOUD_AI, DBMS_CLOUD_AI_AGENT, DBMS_VECTOR, DBMS_VECTOR_CHAIN,
                    DBMS_GAF and DBMS_OGA.
 @d3ka_role         GRAPH/VECTOR/AI capability precondition; no D3KA state is read/written.
 @d3ka_links        Determines whether planned D3KA graph/vector/AI implementation can proceed.
 @ai_role           Discovery only; no model/profile/agent is created or invoked.
 @security          Dictionary metadata only. Output may reveal installed capabilities and
                    must be handled as internal engineering evidence.
 @performance       Small filtered dictionary scans; no business-table access.
 @transaction       SELECT only; no DML, lock, commit or rollback.
 @idempotency       Repeatable; result may legitimately change after Oracle service upgrades.
 @failure_modes     Missing dictionary privilege or changed package/object names can yield
                    error/empty result. Empty result means NOT PROVEN, not unsupported by inference.
 @rollback_recovery None; read-only.
 @tests             Manual CORE-01 review; each capability also has specialized probes 030-060.
 @evidence          CORE-01 compatibility evidence and feature decision matrix.
 @references        Oracle AI Database 26ai Reference; PL/SQL package documentation for the
                    listed components. Package visibility is not feature-certification by itself.
 @links             src/00-precheck/000_database_identity.sql;
                    src/00-precheck/030_graph_capability.sql;
                    src/00-precheck/040_vector_capability.sql;
                    src/00-precheck/060_ai_capability.sql;
                    docs/03-architecture/TECHNOLOGY-DECISION-MATRIX.md
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.02 2026-09-01 — full embedded documentation; queries unchanged.
=============================================================================*/

-- Installed/visible options relevant to converged database architecture.
SELECT parameter, value
FROM v$option
WHERE UPPER(parameter) LIKE '%SPATIAL%'
   OR UPPER(parameter) LIKE '%TEXT%'
   OR UPPER(parameter) LIKE '%GRAPH%'
   OR UPPER(parameter) LIKE '%MACHINE%'
ORDER BY parameter;

-- Visible package/object inventory for AI, VECTOR and graph-related capabilities.
-- Presence is evidence of visibility, not proof that every operation is allowed on this tier.
SELECT owner, object_name, object_type, status
FROM all_objects
WHERE object_name IN ('DBMS_CLOUD_AI','DBMS_CLOUD_AI_AGENT','DBMS_VECTOR','DBMS_VECTOR_CHAIN','DBMS_GAF','DBMS_OGA')
ORDER BY owner, object_name, object_type;
