/*=============================================================================
 @file              src/00-precheck/040_vector_capability.sql
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-01/08
 @workstream        WS-03 Oracle capability / WS-09 Vector semantics
 @source_state      SOURCE_READY
 @production_state  READ_ONLY_NOT_DEPLOYED
 @reversibility     READ_ONLY
 @purpose           Discover visible VECTOR-related types/packages and execute a non-persistent
                    VECTOR constructor expression to prove basic SQL expression capability.
 @business_impact   Validates the semantic-vector foundation before designing embeddings,
                    similarity, Graph RAG or recommendation features for the media core.
 @objects           Reads ALL_TYPES/ALL_OBJECTS and evaluates VECTOR(...) from DUAL only.
 @dependencies      Oracle release/session must expose VECTOR syntax and dictionary metadata.
 @upstream          CORE-00 identity and feature inventory.
 @downstream        CORE-08 vector table/index design, Graph RAG and AI semantic retrieval.
 @d3ka_role         VECTOR
 @d3ka_links        VECTOR is V enrichment attached to D3KA entities/context; it does not replace S/R/T.
 @ai_role           Establishes vector primitive availability; no embedding provider/model call occurs.
 @security          No business data, credentials or model secrets accessed.
 @performance       Metadata reads plus construction of a 3-dimension in-memory expression only.
 @transaction       SELECT-only expression; no persistent data or locks intentionally acquired.
 @idempotency       Repeatable; output is constant for the literal probe.
 @failure_modes     VECTOR syntax/type/package unavailable or invisible, insufficient dictionary
                    access. Failure marks capability NOT PROVEN. Presence of DBMS_VECTOR does not
                    certify vector indexes/model integrations by itself.
 @rollback_recovery None; read-only/non-persistent expression.
 @tests             tests/vector/V-001_vector_distance.sql; V-002_exact_topk.sql and performance
                    tests are later-stage tests after vector objects exist.
 @evidence          CORE-01 VECTOR capability evidence and CORE-08 readiness.
 @references        Oracle AI Vector Search User's Guide / Oracle AI Database 26ai VECTOR SQL documentation.
 @links             src/07-vector/700_tps_vector_type.sql; src/07-vector/710_tps_vector.sql;
                    docs/07-ai-ml/AI-ML-RAG-AGENTS-MASTER-SPEC-v0.02.md
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.02 2026-09-01 — full embedded documentation; probes unchanged.
=============================================================================*/

-- Visible SQL/user-defined type metadata that contains VECTOR in its type name.
SELECT type_name, typecode
FROM all_types
WHERE UPPER(type_name) LIKE '%VECTOR%'
ORDER BY owner, type_name;

-- Vector PL/SQL package visibility.
SELECT owner, object_name, object_type, status
FROM all_objects
WHERE object_name IN ('DBMS_VECTOR','DBMS_VECTOR_CHAIN')
ORDER BY owner, object_name;

-- Constructor-only expression. It creates no table/index/vector row and persists nothing.
SELECT VECTOR('[1,2,3]', 3, FLOAT32) AS vector_probe FROM dual;
