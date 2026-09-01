/*=============================================================================
 @file              src/11-ai/1193_tps_ai_programming_tool_pkg.pks
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-10/11/14/16/18
 @workstream        AI programming tool / bounded automation
 @source_state      SOURCE_READY_PENDING_RUNTIME_COMPILE_TEST
 @production_state  NOT_DEPLOYED
 @reversibility     R1_ADDITIVE package; EXECUTE_BOUNDED routine performs R2 schedule DML
 @purpose           Expose a narrowly scoped PL/SQL tool surface for AI programming workflows:
                    read context, record advisory proposals, and optionally execute a bounded
                    schedule-item insert through the deterministic programming engine.
 @business_impact   Allows the corporate AI to help operate programming without receiving generic
                    SQL/DDL/DML authority over TPSDBCORE01.
 @objects           Creates/replaces TPS_AI_PROGRAMMING_TOOL_PKG specification.
 @dependencies      TPS_AI_GUARD_PKG, TPS_AI_AGENT, TPS_AI_DECISION,
                    TPS_PROGRAMMING_PKG, TPS_CONTINUITY_PKG.
 @upstream          Oracle AI Agent/Select AI wrapper, API/control plane or other approved AI caller.
 @downstream        Programming context, AI decision ledger and bounded schedule-item DML.
 @d3ka_role         AI/ENTITY/TEMPORAL/POLICY
 @d3ka_links        Reads D3KA-linked owner/network programming; proposals reference canonical content entities.
 @ai_role           Concrete database tool interface. `TPS_PROGRAMMING_TOOL` permission is mandatory.
 @security          No dynamic SQL. READ/PROPOSE/EXECUTE_BOUNDED are separately checked. Execute path
                    delegates to TPS_PROGRAMMING_PKG, so rights/assets/overlap cannot be bypassed.
 @performance       Context snapshot is a handful of indexed point/range lookups; execution cost is programming package cost.
 @transaction       Proposal/execution ledger inserts and schedule DML remain in caller transaction; no COMMIT.
 @idempotency       Proposal creates a new decision event. Bounded execution is non-idempotent; caller retry key remains future work.
 @failure_modes     -20401 permission denied; deterministic programming errors propagate; no generic fallback SQL.
 @rollback_recovery Caller rollback before commit. Committed AI decisions remain audit records; schedule history uses lifecycle.
 @tests             tests/ai-control/AIC-001_permission_guard.sql;
                    AIC-002_proposal.sql; AIC-003_bounded_programming.sql.
 @evidence          CORE-10/14/16/18.
 @references        Oracle AI Database 26ai PL/SQL, JSON and AI Agent documentation; project AI authority invariant.
 @links             src/11-ai/1191_tps_ai_guard_pkg.pks;
                    src/12-media/1260_tps_programming_pkg.pks;
                    src/12-media/1280_tps_continuity_pkg.pks;
                    src/11-ai/1130_tps_ai_decision.sql
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.02 2026-09-01 — initial bounded AI programming tool contract.
=============================================================================*/

CREATE OR REPLACE PACKAGE tps_ai_programming_tool_pkg AUTHID DEFINER AS

  /* @routine context_snapshot
     @purpose       Return read-only JSON context for an AI agent about owner/network/current/next programming.
     @inputs        Agent ID, owner entity, evaluation time.
     @outputs       CLOB JSON.
     @reads         AI permission state and programming/continuity state.
     @writes        NONE.
     @calls         TPS_AI_GUARD_PKG.ASSERT_PERMISSION, TPS_PROGRAMMING_PKG current/next,
                    TPS_CONTINUITY_PKG.RESOLVE_NETWORK_ENTITY.
     @called_by     Advisory/programming agent/tool wrapper.
     @d3ka_impact   Reads temporal programming and parent-network relation.
     @ai_impact     Grounding context only; no state change.
     @security      Requires READ grant for TPS_PROGRAMMING_TOOL.
     @transaction   Read-only.
     @performance   Bounded lookups.
     @errors        -20401 permission denied plus underlying DB errors.
     @tests         AIC-001/AIC-002.
  */
  FUNCTION context_snapshot(
      p_ai_agent_id    IN NUMBER,
      p_owner_entity_id IN NUMBER,
      p_at             IN TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP
  ) RETURN CLOB;

  /* @routine propose_schedule_item
     @purpose       Persist an advisory AI proposal without changing the programming schedule.
     @inputs        Agent, schedule/content/context/time/class/priority/confidence.
     @outputs       New TPS_AI_DECISION ID.
     @reads         Agent/model metadata and permission map.
     @writes        TPS_AI_DECISION only.
     @calls         TPS_AI_GUARD_PKG.ASSERT_PERMISSION.
     @called_by     Advisory or bounded programming agent.
     @d3ka_impact   Proposal references canonical schedule/content/context entities.
     @ai_impact     Records model output as proposal, not authorization.
     @security      Requires PROPOSE permission; no schedule DML occurs.
     @transaction   One insert; no COMMIT.
     @performance   Point lookup plus insert.
     @errors        -20401 permission denied; standard FK/JSON errors.
     @tests         AIC-002_proposal.sql.
  */
  FUNCTION propose_schedule_item(
      p_ai_agent_id       IN NUMBER,
      p_schedule_id       IN NUMBER,
      p_content_entity_id IN NUMBER,
      p_context_id        IN NUMBER DEFAULT NULL,
      p_start_at          IN TIMESTAMP WITH TIME ZONE,
      p_end_at            IN TIMESTAMP WITH TIME ZONE,
      p_item_class        IN VARCHAR2,
      p_priority          IN NUMBER DEFAULT 100,
      p_confidence        IN NUMBER DEFAULT NULL
  ) RETURN NUMBER;

  /* @routine execute_bounded_add_item
     @purpose       Execute one AI-requested schedule-item insert only through the deterministic
                    TPS_PROGRAMMING_PKG and record successful AI decision evidence.
     @inputs        Agent plus the exact schedule-item arguments.
     @outputs       New TPS_SCHEDULE_ITEM ID.
     @reads         AI grants and programming dependencies.
     @writes        TPS_SCHEDULE_ITEM through programming package and TPS_AI_DECISION audit row.
     @calls         TPS_AI_GUARD_PKG.ASSERT_PERMISSION; TPS_PROGRAMMING_PKG.ADD_SCHEDULE_ITEM.
     @called_by     BOUNDED_AUTOMATION agent/tool orchestration.
     @d3ka_impact   Adds temporal programming for canonical content only after deterministic checks.
     @ai_impact     This is the bounded execution boundary; AI still cannot issue arbitrary SQL.
     @security      Requires EXECUTE_BOUNDED grant and BOUNDED_AUTOMATION agent class.
     @transaction   All writes atomic in caller transaction; no COMMIT.
     @performance   Guard lookup + programming validation/insert + audit insert.
     @errors        -20401 permission denied; -202xx programming errors propagate and no success audit is inserted.
     @tests         AIC-003_bounded_programming.sql.
  */
  FUNCTION execute_bounded_add_item(
      p_ai_agent_id       IN NUMBER,
      p_schedule_id       IN NUMBER,
      p_content_entity_id IN NUMBER,
      p_context_id        IN NUMBER DEFAULT NULL,
      p_start_at          IN TIMESTAMP WITH TIME ZONE,
      p_end_at            IN TIMESTAMP WITH TIME ZONE,
      p_item_class        IN VARCHAR2,
      p_priority          IN NUMBER DEFAULT 100,
      p_confidence        IN NUMBER DEFAULT NULL
  ) RETURN NUMBER;

END tps_ai_programming_tool_pkg;
/
