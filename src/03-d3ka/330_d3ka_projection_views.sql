/*=============================================================================
 @file              src/03-d3ka/330_d3ka_projection_views.sql
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-04/07/15
 @workstream        WS-05 D3KA kernel / WS-08 Temporal / WS-19 Validation
 @source_state      SOURCE_READY_WITH_LIMITATION
 @production_state  NOT_DEPLOYED
 @reversibility     R1_ADDITIVE
 @purpose           Provide human/API/query-friendly relational projections of D3KA current-open
                    cells and complete relation history while retaining canonical S/R/T identities.
 @business_impact   Allows engineering and applications to inspect source, relation and target
                    semantics without manually joining identity/type tables for common use cases.
 @objects           Creates/replaces TPS_D3KA_ACTIVE_V and TPS_D3KA_HISTORY_V.
 @dependencies      TPS_RELATION, TPS_ENTITY, TPS_RELATION_TYPE.
 @upstream          Persisted D3KA relation cells and entity/relation ontology.
 @downstream        Diagnostics, APIs, validation, human analysis and potentially AI/RAG retrieval.
 @d3ka_role         RELATION/TEMPORAL/PROJECTION
 @d3ka_links        ACTIVE_V exposes S key, R code, T key plus C/Q/assertion/Tv/To metadata;
                    HISTORY_V exposes all persisted relation columns plus R code.
 @ai_role           Safe only as a data projection subject to assertion/provenance/security rules.
                    ACTIVE_V must not be described to AI as "valid now" without extra time filtering.
 @security          Views expose relationship metadata; grants must be controlled. They are not
                    security-barrier/redaction views by definition.
 @performance       Joins TPS_RELATION to two TPS_ENTITY aliases and TPS_RELATION_TYPE. At scale,
                    slice predicates and indexes must be measured; SELECT * in HISTORY_V increases
                    coupling to TPS_RELATION column changes.
 @transaction       Read-only views; no DML/commit/locks introduced.
 @idempotency       CREATE OR REPLACE VIEW is repeatable when dependencies are valid.
 @failure_modes     Missing/invalid dependencies; view invalidation after underlying DDL change.
                    IMPORTANT: ACTIVE_V checks STATE='ACTIVE' and VALID_TO IS NULL but does NOT
                    check VALID_FROM <= SYSTIMESTAMP. A future-dated active/open relation can appear.
                    Use TPS_RELATION_CURRENT_V when point-in-time current-valid semantics are required.
 @rollback_recovery Recreate previous view definitions; base data unaffected.
 @tests             tests/D3KA/D3KA-006_source_slice.sql; D3KA-007_relation_slice.sql;
                    D3KA-008_target_slice.sql; D3KA-009_temporal.sql;
                    tests/temporal/test_relation_current.sql for strict current-time semantics.
 @evidence          CORE-15 projection/slice equivalence evidence; CORE-07 temporal evidence.
 @references        Oracle AI Database 26ai SQL Language Reference: CREATE VIEW, joins, timestamps.
 @links             src/03-d3ka/310_tps_relation.sql;
                    src/05-temporal/500_tps_relation_current_v.sql;
                    docs/04-d3ka/D3KA-ENGINEERING-SPEC-v0.02.md
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.02 2026-09-01 — full documentation and explicit temporal limitation;
                    executable view queries unchanged.
=============================================================================*/

-- ACTIVE_V = active + open-ended relation projection.
-- It is NOT the strict "valid at SYSTIMESTAMP" projection because VALID_FROM is not tested here.
CREATE OR REPLACE VIEW tps_d3ka_active_v AS
SELECT r.relation_id,
       s.entity_id AS source_entity_id,
       s.canonical_key AS source_key,
       rt.relation_code,
       t.entity_id AS target_entity_id,
       t.canonical_key AS target_key,
       r.context_id,
       r.confidence,
       r.assertion_class,
       r.valid_from,
       r.observed_at,
       r.recorded_at
FROM tps_relation r
JOIN tps_entity s ON s.entity_id = r.source_entity_id
JOIN tps_relation_type rt ON rt.relation_type_id = r.relation_type_id
JOIN tps_entity t ON t.entity_id = r.target_entity_id
WHERE r.state = 'ACTIVE'
  AND r.valid_to IS NULL;

-- HISTORY_V intentionally retains active, inactive, superseded and retracted relation history.
CREATE OR REPLACE VIEW tps_d3ka_history_v AS
SELECT r.*, rt.relation_code
FROM tps_relation r
JOIN tps_relation_type rt ON rt.relation_type_id = r.relation_type_id;
