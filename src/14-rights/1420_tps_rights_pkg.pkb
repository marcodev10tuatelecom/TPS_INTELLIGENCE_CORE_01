/*=============================================================================
 @file              src/14-rights/1420_tps_rights_pkg.pkb
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-11/14
 @workstream        WS-12 Policy/rules / WS-15 Rights domain
 @source_state      SOURCE_READY
 @production_state  NOT_DEPLOYED
 @reversibility     R1_ADDITIVE
 @purpose           Implement deterministic point-in-time rights evaluation with explicit
                    DENY precedence, ALLOW fallback and fail-closed UNKNOWN result.
 @business_impact   Prevents content actions from being considered authorized merely because
                    no denial was found. Legal/business rights must positively match ALLOW.
 @objects           Creates/replaces body TPS_RIGHTS_PKG.
 @dependencies      TPS_RIGHTS_PKG spec and TPS_RIGHT_GRANT.
 @upstream          TPS_POLICY_ENGINE_PKG and direct approved rights decision callers.
 @downstream        Content-action authorization, scheduling/placement decisions and audit.
 @d3ka_role         POLICY/TEMPORAL/PROVENANCE
 @d3ka_links        Evaluates policy state linked to canonical entity IDs at Tv=p_at.
 @ai_role           Deterministic boundary. AI/RAG/agents may consume result but may not
                    override DENY or treat UNKNOWN as permitted.
 @security          Definer-rights SELECT over rights table; exposes only status string.
                    Territory/context details remain internal but are NOT currently filtered.
 @performance       One aggregate scan of active matching grants using content,
                    beneficiary, action, validity interval and state predicates. Existing
                    composite index is intended to support this access pattern; measure it.
 @transaction       SELECT only; no DML/commit/rollback/autonomous transaction.
 @idempotency       Deterministic for same consistent rights state and p_at.
 @failure_modes     Standard Oracle query errors. No rows yields aggregate NULL values and
                    therefore UNKNOWN. Concurrent conflicting ALLOW/DENY yields DENY because
                    deny count is evaluated first. Territory/context columns are currently
                    not used by this function; scoped-right semantics remain incomplete until
                    explicit filtering design/tests are added.
 @rollback_recovery Revert body source. Rights rows remain unchanged.
 @tests             tests/performance/PERF-003_schedule_rights.sql;
                    tests/AI/AI-003_policy_boundary.sql; new dedicated rights boundary,
                    conflict, territory/context tests required before certification.
 @evidence          CORE-11 deterministic-rights evidence; CORE-17 performance;
                    CORE-18 security; CORE-20 certification.
 @references        Oracle AI Database 26ai PL/SQL Language Reference; SQL aggregate and
                    timestamp predicate semantics.
 @links             src/14-rights/1400_tps_right_grant.sql;
                    src/14-rights/1410_tps_rights_pkg.pks;
                    src/10-policy/1030_tps_policy_engine_pkg.pkb;
                    docs/05-domain/RIGHTS-LICENSING.md
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.02 2026-09-01 — full embedded/routine documentation; behavior unchanged.
=============================================================================*/

CREATE OR REPLACE PACKAGE BODY tps_rights_pkg AS

  /* @routine decision_for
     @purpose       Aggregate matching active rights grants and return DENY/ALLOW/UNKNOWN.
     @inputs        Canonical content and beneficiary IDs, action code and point in time.
     @outputs       DENY > ALLOW > UNKNOWN precedence.
     @reads         TPS_RIGHT_GRANT.
     @writes        NONE.
     @calls         NONE.
     @called_by     TPS_POLICY_ENGINE_PKG.AUTHORIZE_CONTENT_ACTION.
     @d3ka_impact   Deterministic policy evaluation over D3KA-linked identities and Tv.
     @ai_impact     Non-overridable deterministic boundary for AI-assisted workflows.
     @security      Does not expose grant rows/restrictions, only coarse decision.
     @transaction   Read-only aggregate; no commit.
     @performance   SUM(CASE...) aggregate on indexed lookup path; cardinality/plan must be measured.
     @errors        Standard Oracle errors propagate. UNKNOWN is returned when no active match.
     @tests         PERF-003, AI-003; dedicated rights suite pending.
  */
  FUNCTION decision_for(
    p_content_entity_id IN NUMBER,
    p_beneficiary_entity_id IN NUMBER,
    p_action_code IN VARCHAR2,
    p_at IN TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP
  ) RETURN VARCHAR2 IS
    l_deny NUMBER;
    l_allow NUMBER;
  BEGIN
    -- Current v0.02 decision scope: content + beneficiary + action + time + ACTIVE state.
    -- Territory/context columns exist in TPS_RIGHT_GRANT but are not yet evaluated here;
    -- callers must not assume geographic/context enforcement until that capability is built.
    SELECT SUM(CASE WHEN decision='DENY' THEN 1 ELSE 0 END),
           SUM(CASE WHEN decision='ALLOW' THEN 1 ELSE 0 END)
      INTO l_deny, l_allow
      FROM tps_right_grant
     WHERE content_entity_id=p_content_entity_id
       AND beneficiary_entity_id=p_beneficiary_entity_id
       AND action_code=UPPER(TRIM(p_action_code))
       AND state='ACTIVE'
       AND p_at >= valid_from AND p_at < valid_to;

    -- Explicit DENY always wins over simultaneous ALLOW grants.
    IF NVL(l_deny,0) > 0 THEN RETURN 'DENY'; END IF;
    IF NVL(l_allow,0) > 0 THEN RETURN 'ALLOW'; END IF;
    -- Absence of positive authority is not permission.
    RETURN 'UNKNOWN';
  END;
END tps_rights_pkg;
/
