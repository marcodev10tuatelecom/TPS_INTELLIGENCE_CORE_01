/*=============================================================================
 @file              src/03-d3ka/360_d3ka_coverage_v.sql
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-15
 @workstream        WS-19 D3KA semantic coverage validation
 @source_state      SOURCE_READY_WITH_LIMITATION
 @production_state  NOT_DEPLOYED
 @reversibility     R1_ADDITIVE
 @purpose           Compute a simple global logical D3KA representation ratio from governed
                    fact classes and implementation mappings.
 @business_impact   Provides a machine-queryable progress indicator toward the architectural
                    objective that >=90% of approved business knowledge/relationships be
                    representable/queryable through D3KA/graph semantics.
 @objects           Creates/replaces TPS_D3KA_COVERAGE_V.
 @dependencies      TPS_FACT_CLASS and TPS_FACT_CLASS_MAPPING.
 @upstream          Approved fact catalog and implementation mapping statuses.
 @downstream        D3KA-011 coverage test, engineering dashboards and CORE-15 evidence.
 @d3ka_role         D3KA COVERAGE METRIC
 @d3ka_links        Counts eligible fact classes and those mapped as D3KA_RELATION with
                    IMPLEMENTED/VALIDATED/CERTIFIED status.
 @ai_role           AI may analyze uncovered fact classes but cannot manipulate the denominator,
                    weights or statuses to satisfy certification.
 @security          Engineering/certification metadata only; read access can be broader than writes.
 @performance       Small catalog aggregation with correlated EXISTS; low expected cardinality.
 @transaction       Read-only view; no state mutation.
 @idempotency       CREATE OR REPLACE VIEW repeatable.
 @failure_modes     CRITICAL CERTIFICATION LIMITATION: current calculation is a global unweighted
                    count. It does NOT use TPS_FACT_CLASS.WEIGHT, does NOT calculate coverage per
                    DOMAIN_CODE, and does not validate mapping quality. Therefore a result >=0.90
                    from this view alone MUST NOT be interpreted as satisfying the canonical 90%
                    requirement. Weighted global + per-domain metrics and evidence are still required.
                    Empty eligible denominator returns 0 rather than PASS.
 @rollback_recovery Drop/recreate view; catalog data untouched.
 @tests             tests/D3KA/D3KA-011_coverage.sql; weighted/per-domain coverage tests pending.
 @evidence          CORE-15 preliminary coverage metric; full certification requires additional metrics.
 @references        Project D3KA formal/engineering specifications; Oracle SQL aggregate/EXISTS docs.
 @links             src/03-d3ka/350_tps_fact_class.sql;
                    src/03-d3ka/351_tps_fact_class_mapping.sql;
                    docs/04-d3ka/D3KA-ENGINEERING-SPEC-v0.02.md;
                    src/26-certification/2610_d3ka_cert.sql
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.02 2026-09-01 — full documentation and explicit metric limitation;
                    executable query unchanged.
=============================================================================*/

-- Preliminary unweighted global coverage indicator. Do NOT use alone for >=90% certification.
CREATE OR REPLACE VIEW tps_d3ka_coverage_v AS
SELECT
    COUNT(CASE WHEN fc.d3ka_eligible=1 THEN 1 END) AS eligible_fact_classes,
    COUNT(CASE WHEN fc.d3ka_eligible=1 AND EXISTS (
        SELECT 1 FROM tps_fact_class_mapping m
        WHERE m.fact_class_id=fc.fact_class_id
          AND m.representation_class='D3KA_RELATION'
          AND m.implementation_status IN ('IMPLEMENTED','VALIDATED','CERTIFIED')
    ) THEN 1 END) AS represented_fact_classes,
    CASE
      WHEN COUNT(CASE WHEN fc.d3ka_eligible=1 THEN 1 END)=0 THEN 0
      ELSE ROUND(
        COUNT(CASE WHEN fc.d3ka_eligible=1 AND EXISTS (
            SELECT 1 FROM tps_fact_class_mapping m
            WHERE m.fact_class_id=fc.fact_class_id
              AND m.representation_class='D3KA_RELATION'
              AND m.implementation_status IN ('IMPLEMENTED','VALIDATED','CERTIFIED')
        ) THEN 1 END)
        / COUNT(CASE WHEN fc.d3ka_eligible=1 THEN 1 END), 6)
    END AS d3ka_logical_coverage
FROM tps_fact_class fc
WHERE fc.lifecycle_state='ACTIVE';
