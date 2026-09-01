/*=============================================================================
 @file              src/11-ai/1191_tps_ai_guard_pkg.pks
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-10/11/16/18
 @workstream        AI tool authorization / policy boundary
 @source_state      SOURCE_READY_PENDING_RUNTIME_COMPILE_TEST
 @production_state  NOT_DEPLOYED
 @reversibility     R1_ADDITIVE
 @purpose           Provide a deterministic PL/SQL authorization guard that proves an active AI agent
                    has an active time-valid grant to an active tool at the requested permission mode.
 @business_impact   Makes AI capability enforcement database-verifiable instead of prompt-dependent.
 @objects           Creates/replaces TPS_AI_GUARD_PKG specification.
 @dependencies      TPS_AI_AGENT, TPS_AI_TOOL, TPS_AI_AGENT_TOOL.
 @upstream          Every AI-facing PL/SQL tool wrapper.
 @downstream        Bounded programming/other future agent capabilities.
 @d3ka_role         AI/POLICY/TEMPORAL
 @d3ka_links        Protects AI access to D3KA-backed operations.
 @ai_role           Deterministic permission authority beneath AI.
 @security          AUTHID DEFINER. No dynamic SQL. EXECUTE on this package does not itself grant a tool;
                    successful assertion requires persisted permission rows.
 @performance       Small indexed authorization lookup.
 @transaction       Read-only.
 @idempotency       Deterministic for consistent grant state/time.
 @failure_modes     Missing/inactive agent/tool/grant, insufficient authority class or invalid mode.
 @rollback_recovery Revert package source; grants remain data-driven.
 @tests             tests/ai-control/AIC-001_permission_guard.sql.
 @evidence          CORE-16/18 AI authority evidence.
 @references        Oracle AI Database 26ai PL/SQL and least-privilege security guidance.
 @links             src/11-ai/1190_tps_ai_agent_tool.sql;
                    src/11-ai/1192_tps_ai_guard_pkg.pkb;
                    src/11-ai/1193_tps_ai_programming_tool_pkg.pks
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.02 2026-09-01 — initial deterministic AI tool guard.
=============================================================================*/

CREATE OR REPLACE PACKAGE tps_ai_guard_pkg AUTHID DEFINER AS

  /* @routine permission_allowed
     @purpose       Return whether an agent may use a named tool in a requested mode at p_at.
     @inputs        Agent ID, tool key, READ/PROPOSE/EXECUTE_BOUNDED, evaluation time.
     @outputs       1 allowed, 0 denied.
     @reads         TPS_AI_AGENT, TPS_AI_TOOL, TPS_AI_AGENT_TOOL.
     @writes        NONE.
     @calls         NONE.
     @called_by     ASSERT_PERMISSION and AI tool wrappers.
     @d3ka_impact   Authorization around D3KA-backed tools.
     @ai_impact     Core deterministic guard.
     @security      Fail-closed; missing/invalid state returns 0.
     @transaction   Read-only.
     @performance   Indexed count/lookup.
     @errors        Invalid mode returns 0; unexpected Oracle errors propagate.
     @tests         AIC-001_permission_guard.sql.
  */
  FUNCTION permission_allowed(
      p_ai_agent_id    IN NUMBER,
      p_tool_key       IN VARCHAR2,
      p_permission_mode IN VARCHAR2,
      p_at             IN TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP
  ) RETURN NUMBER;

  /* @routine assert_permission
     @purpose       Raise a controlled error unless PERMISSION_ALLOWED=1.
     @inputs        Same as permission_allowed.
     @outputs       NONE on success.
     @reads         AI agent/tool/grant tables through PERMISSION_ALLOWED.
     @writes        NONE.
     @calls         PERMISSION_ALLOWED.
     @called_by     Every stateful/advisory AI PL/SQL tool entry point.
     @d3ka_impact   Enforces policy before D3KA-backed action.
     @ai_impact     Converts permission metadata into enforceable runtime gate.
     @security      Fail-closed.
     @transaction   Read-only.
     @performance   One authorization lookup.
     @errors        -20401 when denied.
     @tests         AIC-001_permission_guard.sql.
  */
  PROCEDURE assert_permission(
      p_ai_agent_id     IN NUMBER,
      p_tool_key        IN VARCHAR2,
      p_permission_mode IN VARCHAR2,
      p_at              IN TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP
  );

END tps_ai_guard_pkg;
/
