/*=============================================================================
 @file              src/14-rights/1410_tps_rights_pkg.pks
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-11/14
 @workstream        WS-12 Policy/rules / WS-15 Rights domain
 @source_state      SOURCE_READY
 @production_state  NOT_DEPLOYED
 @reversibility     R1_ADDITIVE
 @purpose           Expose the deterministic rights decision contract used to decide
                    whether one beneficiary may perform one action on one content entity
                    at a point in time.
 @business_impact   Establishes a fail-closed legal/business decision primitive before
                    broadcast, publication, placement or other content action is authorized.
 @objects           Creates/replaces package specification TPS_RIGHTS_PKG.
 @dependencies      TPS_RIGHT_GRANT at body/runtime level.
 @upstream          Policy engine and other authorized rights consumers.
 @downstream        TPS_POLICY_ENGINE_PKG, schedule/content authorization, tests/audit.
 @d3ka_role         POLICY/TEMPORAL/PROVENANCE
 @d3ka_links        Evaluates deterministic authorization adjacent to D3KA content/entity
                    relationships using Tv and E-backed rights state.
 @ai_role           NONE probabilistic. AI recommendations must accept this deterministic
                    result as an authorization boundary and cannot override DENY/UNKNOWN.
 @security          AUTHID DEFINER; grant EXECUTE only to approved policy/runtime identities.
                    Underlying rights-table DML should remain inaccessible to normal callers.
 @performance       Contract is point decision; body currently aggregates matching grants
                    using the rights lookup index. Benchmark under schedule/ad-load workload.
 @transaction       Read-only decision routine; no commit or DML in current implementation.
 @idempotency       Same consistent database state/time inputs should return the same result.
 @failure_modes     Returns `DENY`, `ALLOW`, or `UNKNOWN`; UNKNOWN is not ALLOW. Standard
                    Oracle errors remain failures and callers must fail closed.
 @rollback_recovery Replace package spec/body with prior version; rights data untouched.
 @tests             tests/performance/PERF-003_schedule_rights.sql;
                    tests/AI/AI-003_policy_boundary.sql; dedicated rights tests pending.
 @evidence          CORE-11 rights decision evidence and CORE-20 certification.
 @references        Oracle AI Database 26ai PL/SQL Language Reference.
 @links             src/14-rights/1400_tps_right_grant.sql;
                    src/14-rights/1420_tps_rights_pkg.pkb;
                    src/10-policy/1020_tps_policy_engine_pkg.pks;
                    docs/05-domain/RIGHTS-LICENSING.md
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.02 2026-09-01 — full embedded/routine documentation; API unchanged.
=============================================================================*/

CREATE OR REPLACE PACKAGE tps_rights_pkg AUTHID DEFINER AS

  /* @routine decision_for
     @purpose       Return deterministic rights status for content/beneficiary/action/time.
     @inputs        p_content_entity_id: canonical content entity.
                    p_beneficiary_entity_id: canonical actor/service/station entity.
                    p_action_code: normalized case-insensitive action contract.
                    p_at: point in time, defaults SYSTIMESTAMP.
     @outputs       `DENY` if any matching active deny exists; otherwise `ALLOW` if any
                    active allow exists; otherwise `UNKNOWN`.
     @reads         TPS_RIGHT_GRANT.
     @writes        NONE.
     @calls         NONE in current body.
     @called_by     TPS_POLICY_ENGINE_PKG.AUTHORIZE_CONTENT_ACTION and authorized consumers.
     @d3ka_impact   Reads rights policy over D3KA-linked canonical entity IDs and Tv window.
     @ai_impact     Deterministic boundary; AI cannot reinterpret UNKNOWN as ALLOW.
     @security      Definer reads sensitive rights data; caller gets only coarse decision.
     @transaction   Read-only; no locks intentionally acquired, no COMMIT.
     @performance   Aggregate over lookup predicates; index exists on key/time/state columns.
     @errors        Standard Oracle errors fail the call; caller must fail closed.
     @tests         PERF-003, AI-003 and future dedicated rights unit/boundary tests.
  */
  FUNCTION decision_for(
    p_content_entity_id     IN NUMBER,
    p_beneficiary_entity_id IN NUMBER,
    p_action_code           IN VARCHAR2,
    p_at                    IN TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP
  ) RETURN VARCHAR2;
END tps_rights_pkg;
/
