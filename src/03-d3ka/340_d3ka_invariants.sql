/*=============================================================================
 @file              src/03-d3ka/340_d3ka_invariants.sql
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-15
 @workstream        WS-19 D3KA/graph validation
 @source_state      SOURCE_READY_WITH_LIMITATION
 @production_state  NOT_DEPLOYED
 @reversibility     R1_ADDITIVE
 @purpose           Materialize a read-only diagnostic projection of selected D3KA
                    invariant violations that should never exist in certified relation data.
 @business_impact   Makes semantic corruption visible and queryable for certification,
                    monitoring and incident investigation instead of relying only on application logic.
 @objects           Creates/replaces TPS_D3KA_INVARIANT_VIOLATIONS_V.
 @dependencies      TPS_RELATION and TPS_RELATION_TYPE.
 @upstream          Persisted D3KA relation cells and ontology flags.
 @downstream        D3KA-010 invariant tests, certification summaries, future observability alerts.
 @d3ka_role         RELATION/CONTEXT/PROVENANCE/TEMPORAL validation
 @d3ka_links        Checks selected S/R/T self-rule, C requirement, E requirement and Tv validity.
 @ai_role           AI may use violations for diagnosis, but remediation requires governed deterministic action.
 @security          Diagnostic relation IDs and violation classes are internal engineering data.
 @performance       UNION ALL performs multiple scans/joins of TPS_RELATION. Appropriate for validation;
                    continuous monitoring at large scale requires measured cost and possibly specialized queries.
 @transaction       View is read-only; no corrective DML.
 @idempotency       CREATE OR REPLACE VIEW repeatable.
 @failure_modes     This view is intentionally NOT exhaustive. It does not currently test relation
                    source/target entity-type mismatch, confidence range, FK integrity (handled by constraints),
                    duplicate active cell (unique index), inactive endpoint semantics, or every future ontology invariant.
                    Zero rows means only these four rules have no visible violation; it is not total D3KA certification.
 @rollback_recovery Drop/recreate view; no base data affected.
 @tests             tests/D3KA/D3KA-010_invariants.sql and earlier negative D3KA tests.
 @evidence          CORE-15 invariant evidence; CORE-20 summary must combine all other constraint/tests.
 @references        Oracle AI Database 26ai SQL Language Reference: CREATE VIEW, UNION ALL, joins.
 @links             src/03-d3ka/300_tps_relation_type.sql;
                    src/03-d3ka/310_tps_relation.sql;
                    src/03-d3ka/320_tps_d3ka_pkg.pks;
                    src/26-certification/2610_d3ka_cert.sql
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.02 2026-09-01 — full documentation/coverage limitation; query unchanged.
=============================================================================*/

-- Selected semantic invariant violations. One relation may appear more than once if it violates multiple rules.
CREATE OR REPLACE VIEW tps_d3ka_invariant_violations_v AS
SELECT r.relation_id, 'SELF_RELATION_NOT_ALLOWED' AS violation
FROM tps_relation r JOIN tps_relation_type rt ON rt.relation_type_id=r.relation_type_id
WHERE rt.allow_self=0 AND r.source_entity_id=r.target_entity_id
UNION ALL
SELECT r.relation_id, 'CONTEXT_REQUIRED'
FROM tps_relation r JOIN tps_relation_type rt ON rt.relation_type_id=r.relation_type_id
WHERE rt.requires_context=1 AND r.context_id IS NULL
UNION ALL
SELECT r.relation_id, 'PROVENANCE_REQUIRED'
FROM tps_relation r JOIN tps_relation_type rt ON rt.relation_type_id=r.relation_type_id
WHERE rt.requires_provenance=1 AND r.provenance_source_id IS NULL
UNION ALL
SELECT r.relation_id, 'INVALID_VALIDITY'
FROM tps_relation r WHERE r.valid_to IS NOT NULL AND r.valid_to <= r.valid_from;
