/*=============================================================================
 @file              src/05-temporal/500_tps_relation_current_v.sql
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-07
 @workstream        WS-08 Temporal engine
 @source_state      SOURCE_READY
 @production_state  NOT_DEPLOYED
 @reversibility     R1_ADDITIVE
 @purpose           Define the canonical current-valid-time projection of D3KA
                    relations using half-open validity semantics and ACTIVE lifecycle.
 @business_impact   Gives applications, graph/RAG queries and business logic one
                    consistent definition of "relation valid now" instead of duplicating
                    time predicates across radio, TV, rights, schedule and commercial code.
 @objects           Creates/replaces view TPS_RELATION_CURRENT_V.
 @dependencies      TPS_RELATION.
 @upstream          Persisted D3KA relation history.
 @downstream        Graph neighbors, current-state APIs, policy/rights/scheduling logic,
                    analytics and AI retrieval that explicitly needs current facts.
 @d3ka_role         TEMPORAL/RELATION
 @d3ka_links        Projects D3KA cells whose Tv interval contains SYSTIMESTAMP and whose
                    lifecycle state is ACTIVE; S/R/T/C/E/Q values are preserved unchanged.
 @ai_role           AI/RAG may consume the view as current context. This does not make
                    retrieved relations verified facts beyond their own assertion/provenance class.
 @security          View exposes the same columns as TPS_RELATION. Grants must be explicit;
                    this view is not a row-level security boundary by itself.
 @performance       Time predicate plus STATE over TPS_RELATION. At scale, current-relation
                    access paths/index design must be measured under CORE-17; SYSTIMESTAMP
                    makes the result time-dependent and prevents treating it as static cache.
 @transaction       Read-only view; no DML/commit/lock behavior is introduced.
 @idempotency       CREATE OR REPLACE VIEW is repeatable when dependencies are valid.
 @failure_modes     Missing/invalid TPS_RELATION or insufficient CREATE VIEW/SELECT privilege.
                    Query performance may degrade without appropriate measured access paths.
 @rollback_recovery Drop/recreate the view from previous source; base relation data is untouched.
 @tests             tests/temporal/test_relation_current.sql;
                    tests/D3KA/D3KA-009_temporal.sql.
 @evidence          CORE-07 temporal semantics evidence; CORE-15 D3KA temporal validation;
                    CORE-17 performance evidence; CORE-20 certification.
 @references        Oracle AI Database 26ai SQL Language Reference: CREATE VIEW,
                    SYSTIMESTAMP and TIMESTAMP WITH TIME ZONE comparison semantics.
 @links             src/03-d3ka/310_tps_relation.sql;
                    src/05-temporal/510_tps_temporal_pkg.pks;
                    docs/03-architecture/MASTER-DATABASE-ENGINEERING-SPEC-v0.02.md;
                    docs/04-d3ka/D3KA-ENGINEERING-SPEC-v0.02.md
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.02 2026-09-01 — full embedded documentation; view query unchanged.
=============================================================================*/

-- Current-valid projection uses [VALID_FROM, VALID_TO) half-open interval semantics.
CREATE OR REPLACE VIEW tps_relation_current_v AS
SELECT r.*
  FROM tps_relation r
 WHERE r.state = 'ACTIVE'
   AND r.valid_from <= SYSTIMESTAMP
   AND (r.valid_to IS NULL OR r.valid_to > SYSTIMESTAMP);
