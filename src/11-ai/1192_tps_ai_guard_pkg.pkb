/*=============================================================================
 @file              src/11-ai/1192_tps_ai_guard_pkg.pkb
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-10/11/16/18
 @workstream        AI tool authorization / policy boundary
 @source_state      SOURCE_READY_PENDING_RUNTIME_COMPILE_TEST
 @production_state  NOT_DEPLOYED
 @reversibility     R1_ADDITIVE
 @purpose           Implement fail-closed AI permission enforcement using agent state/authority,
                    tool state and time-valid agent-tool permission grants.
 @business_impact   Stops prompt injection or model behavior from manufacturing capabilities that
                    were never granted in the database.
 @objects           Creates/replaces TPS_AI_GUARD_PKG body.
 @dependencies      TPS_AI_AGENT, TPS_AI_TOOL, TPS_AI_AGENT_TOOL and package specification.
 @upstream          Calls through TPS_AI_GUARD_PKG.
 @downstream        TPS_AI_PROGRAMMING_TOOL_PKG and future AI capability wrappers.
 @d3ka_role         AI/POLICY/TEMPORAL
 @d3ka_links        Authorization boundary around D3KA-backed operations.
 @ai_role           Deterministic guard; model text has no effect on this decision.
 @security          Static SQL; no dynamic dispatch. Tool.AUTHORITY_CLASS is not trusted as sole enforcement;
                    persisted permission mode + agent authority class are checked explicitly.
 @performance       Point/unique-ish lookup and COUNT on indexed authorization map.
 @transaction       Read-only.
 @idempotency       Deterministic for consistent state/time.
 @failure_modes     Invalid mode/inactive/missing objects/grants return deny; unexpected DB errors propagate.
 @rollback_recovery Revert body source.
 @tests             tests/ai-control/AIC-001_permission_guard.sql.
 @evidence          CORE-16/18.
 @references        Oracle AI Database 26ai PL/SQL/security documentation.
 @links             src/11-ai/1191_tps_ai_guard_pkg.pks; src/11-ai/1190_tps_ai_agent_tool.sql
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.02 2026-09-01 — initial implementation.
=============================================================================*/

CREATE OR REPLACE PACKAGE BODY tps_ai_guard_pkg AS

  FUNCTION permission_allowed(
      p_ai_agent_id     IN NUMBER,
      p_tool_key        IN VARCHAR2,
      p_permission_mode IN VARCHAR2,
      p_at              IN TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP
  ) RETURN NUMBER IS
      l_mode            VARCHAR2(30) := UPPER(TRIM(p_permission_mode));
      l_agent_authority VARCHAR2(40);
      l_agent_state     VARCHAR2(30);
      l_tool_id         NUMBER;
      l_tool_state      VARCHAR2(30);
      l_grant_count     NUMBER;
  BEGIN
      IF l_mode NOT IN ('READ','PROPOSE','EXECUTE_BOUNDED') THEN
          RETURN 0;
      END IF;

      BEGIN
          SELECT authority_class, state
            INTO l_agent_authority, l_agent_state
            FROM tps_ai_agent
           WHERE ai_agent_id = p_ai_agent_id;
      EXCEPTION
          WHEN NO_DATA_FOUND THEN
              RETURN 0;
      END;

      IF l_agent_state <> 'ACTIVE' THEN
          RETURN 0;
      END IF;

      /* ANALYTICS_ONLY may read but cannot propose/execute. ADVISORY may read/propose.
         Only BOUNDED_AUTOMATION may execute bounded state changes. */
      IF l_mode = 'PROPOSE' AND l_agent_authority NOT IN ('ADVISORY','BOUNDED_AUTOMATION') THEN
          RETURN 0;
      ELSIF l_mode = 'EXECUTE_BOUNDED' AND l_agent_authority <> 'BOUNDED_AUTOMATION' THEN
          RETURN 0;
      END IF;

      BEGIN
          SELECT ai_tool_id, state
            INTO l_tool_id, l_tool_state
            FROM tps_ai_tool
           WHERE tool_key = UPPER(TRIM(p_tool_key));
      EXCEPTION
          WHEN NO_DATA_FOUND THEN
              RETURN 0;
      END;

      IF l_tool_state <> 'ACTIVE' THEN
          RETURN 0;
      END IF;

      SELECT COUNT(*)
        INTO l_grant_count
        FROM tps_ai_agent_tool
       WHERE ai_agent_id = p_ai_agent_id
         AND ai_tool_id = l_tool_id
         AND permission_mode = l_mode
         AND state = 'ACTIVE'
         AND valid_from <= p_at
         AND (valid_to IS NULL OR p_at < valid_to);

      RETURN CASE WHEN l_grant_count > 0 THEN 1 ELSE 0 END;
  END permission_allowed;

  PROCEDURE assert_permission(
      p_ai_agent_id     IN NUMBER,
      p_tool_key        IN VARCHAR2,
      p_permission_mode IN VARCHAR2,
      p_at              IN TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP
  ) IS
  BEGIN
      IF permission_allowed(p_ai_agent_id, p_tool_key, p_permission_mode, p_at) <> 1 THEN
          RAISE_APPLICATION_ERROR(-20401, 'TPS_AI_TOOL_PERMISSION_DENIED');
      END IF;
  END assert_permission;

END tps_ai_guard_pkg;
/
