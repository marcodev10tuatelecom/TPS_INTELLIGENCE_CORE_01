/*=============================================================================
 @file              src/10-policy/1030_tps_policy_engine_pkg.pkb
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-11
 @workstream        WS-12 Policy/rules
 @source_state      SOURCE_READY_WITH_LIMITATION
 @production_state  NOT_DEPLOYED
 @reversibility     R1_ADDITIVE
 @purpose           Implement the current deterministic content-action boundary by
                    delegating to rights evaluation and failing closed when rights are
                    denied or unknown.
 @business_impact   Ensures lack of positive rights is not treated as permission. This is
                    one stage of the future full authorization pipeline.
 @objects           Creates/replaces body TPS_POLICY_ENGINE_PKG.
 @dependencies      TPS_POLICY_ENGINE_PKG spec; TPS_RIGHTS_PKG.
 @upstream          Calls to AUTHORIZE_CONTENT_ACTION.
 @downstream        Action-gating caller receives current rights-layer authorization code.
 @d3ka_role         POLICY
 @d3ka_links        Applies A/policy decision to content/beneficiary identities and Tv.
 @ai_role           Deterministic authority boundary. AI recommendation is subordinate.
 @security          Definer-rights package. Caller receives coarse decision, not raw rights rows.
 @performance       Exactly one TPS_RIGHTS_PKG.DECISION_FOR call plus scalar branch logic.
 @transaction       Read-only current implementation; no commit/rollback.
 @idempotency       Deterministic for a consistent rights state and p_at.
 @failure_modes     Rights DENY -> DENY_RIGHTS; rights UNKNOWN -> DENY_UNKNOWN_RIGHTS;
                    rights ALLOW -> ALLOW. Any Oracle exception propagates and must fail closed.
                    CRITICAL LIMITATION: TPS_POLICY and TPS_RULE are not read here; schedule,
                    commercial frequency, regulatory, competitor-conflict and operational
                    validations are not yet implemented. `ALLOW` is therefore rights-layer
                    allow only, not final broadcast authorization.
 @rollback_recovery Revert package body; no persisted state is modified.
 @tests             tests/AI/AI-003_policy_boundary.sql;
                    tests/performance/PERF-003_schedule_rights.sql;
                    full multi-stage policy tests pending.
 @evidence          CORE-11 partial implementation evidence. Certification remains blocked
                    until policy/rule/schedule/operational stages are complete and tested.
 @references        Oracle AI Database 26ai PL/SQL Language Reference; project deterministic
                    authorization architecture.
 @links             src/10-policy/1020_tps_policy_engine_pkg.pks;
                    src/14-rights/1410_tps_rights_pkg.pks;
                    src/10-policy/1000_tps_policy.sql; src/10-policy/1010_tps_rule.sql;
                    docs/01-business/BUSINESS-RULES.md
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.02 2026-09-01 — full docs/limitations; executable behavior unchanged.
=============================================================================*/

CREATE OR REPLACE PACKAGE BODY tps_policy_engine_pkg AS

  /* @routine authorize_content_action
     @purpose       Convert deterministic rights decision into current authorization code.
     @inputs        Content entity, beneficiary entity, action and point in time.
     @outputs       DENY_RIGHTS, DENY_UNKNOWN_RIGHTS or ALLOW.
     @reads         Indirect TPS_RIGHT_GRANT via TPS_RIGHTS_PKG.
     @writes        NONE.
     @calls         TPS_RIGHTS_PKG.DECISION_FOR.
     @called_by     Future media/schedule/API/AI gating workflow.
     @d3ka_impact   A/policy decision over D3KA-linked identities.
     @ai_impact     AI cannot override result; current ALLOW is not yet final operational authorization.
     @security      Coarse fail-closed decision endpoint.
     @transaction   Read-only.
     @performance   One delegated rights query plus O(1) branching.
     @errors        Rights/Oracle errors propagate; callers must fail closed.
     @tests         AI-003, PERF-003; complete policy suite pending.
  */
  FUNCTION authorize_content_action(
    p_content_entity_id IN NUMBER,
    p_beneficiary_entity_id IN NUMBER,
    p_action_code IN VARCHAR2,
    p_at IN TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP
  ) RETURN VARCHAR2 IS
    l_rights VARCHAR2(20);
  BEGIN
    l_rights := tps_rights_pkg.decision_for(
      p_content_entity_id,
      p_beneficiary_entity_id,
      p_action_code,
      p_at
    );

    -- Fail closed on explicit denial or absence of positive rights authority.
    IF l_rights='DENY' THEN RETURN 'DENY_RIGHTS'; END IF;
    IF l_rights='UNKNOWN' THEN RETURN 'DENY_UNKNOWN_RIGHTS'; END IF;

    -- v0.02 LIMITATION: this ALLOW means RIGHTS LAYER ALLOW ONLY.
    -- Generic TPS_POLICY/TPS_RULE, scheduling, commercial and operational validation
    -- are not evaluated by this body yet and must be added before final authorization.
    RETURN 'ALLOW';
  END;
END tps_policy_engine_pkg;
/
