/*=============================================================================
 @file              src/10-policy/1020_tps_policy_engine_pkg.pks
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-11
 @workstream        WS-12 Policy/rules
 @source_state      SOURCE_READY_WITH_LIMITATION
 @production_state  NOT_DEPLOYED
 @reversibility     R1_ADDITIVE
 @purpose           Expose a deterministic content-action authorization boundary.
 @business_impact   Provides the final non-AI decision point before a content action can be
                    considered permitted by the current policy implementation.
 @objects           Creates/replaces package specification TPS_POLICY_ENGINE_PKG.
 @dependencies      TPS_RIGHTS_PKG at body/runtime level.
 @upstream          Schedule/media/commercial/API/AI workflows requesting authorization.
 @downstream        Future authorized action pipeline, audit and certification.
 @d3ka_role         POLICY
 @d3ka_links        Consumes canonical entity IDs and temporal rights state to apply A/policy
                    authorization to actions proposed from D3KA context.
 @ai_role           This package is a deterministic authority boundary. AI recommendations
                    may call it but cannot override its result.
 @security          AUTHID DEFINER; EXECUTE must be restricted to approved service roles.
                    Returned value should be audited when it gates externally visible actions.
 @performance       Point authorization call; current implementation delegates one rights query.
 @transaction       Read-only in current body; no commit/rollback.
 @idempotency       Deterministic for consistent underlying rights state and p_at.
 @failure_modes     Current v0.02 limitation: generic TPS_POLICY/TPS_RULE rows are NOT evaluated.
                    Only TPS_RIGHTS_PKG is consulted. Therefore `ALLOW` means rights-layer allow,
                    not yet complete policy/schedule/commercial/operational authorization.
                    Callers must not label this routine as final broadcast authorization until
                    the remaining policy stages and tests are implemented.
 @rollback_recovery Restore previous package specification/body; no state mutation.
 @tests             tests/AI/AI-003_policy_boundary.sql;
                    tests/performance/PERF-003_schedule_rights.sql;
                    expanded policy-rule/schedule/operational authorization tests pending.
 @evidence          CORE-11 partial policy-engine evidence. CORE-11 cannot be certified solely
                    from this v0.02 implementation because generic rules are not evaluated.
 @references        Oracle AI Database 26ai PL/SQL Language Reference; project policy ADRs.
 @links             src/10-policy/1000_tps_policy.sql; src/10-policy/1010_tps_rule.sql;
                    src/10-policy/1030_tps_policy_engine_pkg.pkb;
                    src/14-rights/1410_tps_rights_pkg.pks;
                    docs/07-ai-ml/AI-ML-RAG-AGENTS-MASTER-SPEC-v0.02.md
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.02 2026-09-01 — full documentation and explicit limitation; API unchanged.
=============================================================================*/

CREATE OR REPLACE PACKAGE tps_policy_engine_pkg AUTHID DEFINER AS

  /* @routine authorize_content_action
     @purpose       Evaluate current deterministic authorization for an action on content.
     @inputs        Content entity, beneficiary entity, action code and evaluation time.
     @outputs       Current body returns ALLOW, DENY_RIGHTS or DENY_UNKNOWN_RIGHTS.
                    This is NOT yet a complete multi-policy authorization result.
     @reads         Indirectly TPS_RIGHT_GRANT through TPS_RIGHTS_PKG.
     @writes        NONE.
     @calls         TPS_RIGHTS_PKG.DECISION_FOR.
     @called_by     Media/schedule/API/AI action-gating workflows.
     @d3ka_impact   Applies A/policy boundary to D3KA-linked content/beneficiary identities.
     @ai_impact     Required deterministic boundary; AI cannot turn deny/unknown into allow.
     @security      Definer-rights decision endpoint; grant EXECUTE narrowly and audit use.
     @transaction   Read-only in current implementation.
     @performance   One rights-decision call; future stages add policy/schedule/operational cost.
     @errors        Standard Oracle errors propagate and must be treated fail-closed.
     @tests         AI-003, PERF-003; full policy authorization suite pending.
  */
  FUNCTION authorize_content_action(
    p_content_entity_id     IN NUMBER,
    p_beneficiary_entity_id IN NUMBER,
    p_action_code           IN VARCHAR2,
    p_at                    IN TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP
  ) RETURN VARCHAR2;
END tps_policy_engine_pkg;
/
