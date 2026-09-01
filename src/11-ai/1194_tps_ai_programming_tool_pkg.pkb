/*=============================================================================
 @file              src/11-ai/1194_tps_ai_programming_tool_pkg.pkb
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-10/11/14/16/18
 @workstream        AI programming tool / bounded automation
 @source_state      SOURCE_READY_PENDING_RUNTIME_COMPILE_TEST
 @production_state  NOT_DEPLOYED
 @reversibility     R1_ADDITIVE body; bounded execution performs R2 schedule DML
 @purpose           Implement the database-enforced AI programming tool: read context,
                    persist advisory proposals and perform only explicitly granted bounded
                    schedule-item insertion through deterministic programming validation.
 @business_impact   Provides a concrete AI-to-PL/SQL control plane without generic SQL authority.
 @objects           Creates/replaces TPS_AI_PROGRAMMING_TOOL_PKG body.
 @dependencies      Package spec, TPS_AI_GUARD_PKG, TPS_AI_AGENT, TPS_AI_DECISION,
                    TPS_PROGRAMMING_PKG, TPS_CONTINUITY_PKG.
 @upstream          AI/tool caller.
 @downstream        AI decision ledger and programming schedule state.
 @d3ka_role         AI/ENTITY/TEMPORAL/POLICY
 @d3ka_links        Uses canonical owner/content/context IDs and network relation context.
 @ai_role           Concrete bounded tool implementation.
 @security          Static PL/SQL only. Prompt content cannot change permission mode or call arbitrary objects.
 @performance       Bounded lookups/inserts; no unbounded dynamic query generation.
 @transaction       No COMMIT or full ROLLBACK. EXECUTE_BOUNDED establishes an internal SAVEPOINT
                    and ROLLBACK TO SAVEPOINT on any downstream failure so schedule DML and success
                    audit insertion behave atomically while preserving the caller's earlier transaction work.
 @idempotency       Proposal/execution events are not retry-deduplicated yet; request ledger is future work.
 @failure_modes     Permission denial/programming validation failures propagate. Any failure after bounded
                    schedule insertion rolls back that bounded operation to the local savepoint.
 @rollback_recovery Local savepoint protects bounded operation; caller owns final COMMIT/ROLLBACK.
 @tests             tests/ai-control/* and compile validation.
 @evidence          CORE-10/14/16/18.
 @references        Oracle AI Database 26ai PL/SQL transaction control, JSON and AI Agent documentation.
 @links             src/11-ai/1193_tps_ai_programming_tool_pkg.pks;
                    src/12-media/1261_tps_programming_pkg.pkb;
                    src/11-ai/1130_tps_ai_decision.sql
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.02 2026-09-01 — initial implementation; local atomicity savepoint added.
=============================================================================*/

CREATE OR REPLACE PACKAGE BODY tps_ai_programming_tool_pkg AS

  FUNCTION context_snapshot(
      p_ai_agent_id     IN NUMBER,
      p_owner_entity_id IN NUMBER,
      p_at              IN TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP
  ) RETURN CLOB IS
      l_current_item NUMBER;
      l_next_item    NUMBER;
      l_network_id   NUMBER;
      l_json         CLOB;
  BEGIN
      tps_ai_guard_pkg.assert_permission(
          p_ai_agent_id,
          'TPS_PROGRAMMING_TOOL',
          'READ',
          p_at
      );

      l_current_item := tps_programming_pkg.current_item(p_owner_entity_id, p_at);
      l_next_item := tps_programming_pkg.next_item(p_owner_entity_id, p_at);
      l_network_id := tps_continuity_pkg.resolve_network_entity(p_owner_entity_id, p_at);

      SELECT JSON_OBJECT(
          'owner_entity_id' VALUE p_owner_entity_id,
          'evaluated_at' VALUE TO_CHAR(p_at, 'YYYY-MM-DD"T"HH24:MI:SS.FF TZH:TZM'),
          'network_entity_id' VALUE l_network_id,
          'current_schedule_item_id' VALUE l_current_item,
          'next_schedule_item_id' VALUE l_next_item
          RETURNING CLOB
      )
      INTO l_json
      FROM dual;

      RETURN l_json;
  END context_snapshot;

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
  ) RETURN NUMBER IS
      l_model_id NUMBER;
      l_decision_id NUMBER;
  BEGIN
      tps_ai_guard_pkg.assert_permission(
          p_ai_agent_id,
          'TPS_PROGRAMMING_TOOL',
          'PROPOSE',
          SYSTIMESTAMP
      );

      SELECT ai_model_id
        INTO l_model_id
        FROM tps_ai_agent
       WHERE ai_agent_id = p_ai_agent_id
         AND state = 'ACTIVE';

      INSERT INTO tps_ai_decision(
          ai_agent_id,
          ai_model_id,
          context_id,
          input_summary_json,
          output_json,
          confidence,
          policy_result,
          final_action,
          human_override
      ) VALUES (
          p_ai_agent_id,
          l_model_id,
          p_context_id,
          JSON_OBJECT(
              'operation' VALUE 'PROPOSE_SCHEDULE_ITEM',
              'schedule_id' VALUE p_schedule_id
              RETURNING JSON
          ),
          JSON_OBJECT(
              'content_entity_id' VALUE p_content_entity_id,
              'start_at' VALUE TO_CHAR(p_start_at, 'YYYY-MM-DD"T"HH24:MI:SS.FF TZH:TZM'),
              'end_at' VALUE TO_CHAR(p_end_at, 'YYYY-MM-DD"T"HH24:MI:SS.FF TZH:TZM'),
              'item_class' VALUE UPPER(TRIM(p_item_class)),
              'priority' VALUE p_priority
              RETURNING JSON
          ),
          p_confidence,
          'PENDING_DETERMINISTIC_VALIDATION',
          'PROPOSE_SCHEDULE_ITEM',
          0
      ) RETURNING ai_decision_id INTO l_decision_id;

      RETURN l_decision_id;
  END propose_schedule_item;

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
  ) RETURN NUMBER IS
      l_model_id NUMBER;
      l_item_id NUMBER;
      l_decision_id NUMBER;
  BEGIN
      tps_ai_guard_pkg.assert_permission(
          p_ai_agent_id,
          'TPS_PROGRAMMING_TOOL',
          'EXECUTE_BOUNDED',
          SYSTIMESTAMP
      );

      SAVEPOINT tps_ai_bounded_exec;

      BEGIN
          /* This is the only programming state change in the AI wrapper. All business validation
             remains in TPS_PROGRAMMING_PKG; the AI wrapper cannot bypass it. */
          l_item_id := tps_programming_pkg.add_schedule_item(
              p_schedule_id       => p_schedule_id,
              p_content_entity_id => p_content_entity_id,
              p_context_id        => p_context_id,
              p_start_at          => p_start_at,
              p_end_at            => p_end_at,
              p_item_class        => p_item_class,
              p_priority          => p_priority
          );

          SELECT ai_model_id
            INTO l_model_id
            FROM tps_ai_agent
           WHERE ai_agent_id = p_ai_agent_id
             AND state = 'ACTIVE';

          INSERT INTO tps_ai_decision(
              ai_agent_id,
              ai_model_id,
              context_id,
              input_summary_json,
              output_json,
              confidence,
              policy_result,
              final_action,
              human_override
          ) VALUES (
              p_ai_agent_id,
              l_model_id,
              p_context_id,
              JSON_OBJECT(
                  'operation' VALUE 'EXECUTE_BOUNDED_ADD_ITEM',
                  'schedule_id' VALUE p_schedule_id,
                  'content_entity_id' VALUE p_content_entity_id
                  RETURNING JSON
              ),
              JSON_OBJECT(
                  'schedule_item_id' VALUE l_item_id,
                  'status' VALUE 'INSERTED_BY_DETERMINISTIC_PROGRAMMING_ENGINE'
                  RETURNING JSON
              ),
              p_confidence,
              'DETERMINISTIC_CHECKS_PASSED',
              'ADD_SCHEDULE_ITEM',
              0
          ) RETURNING ai_decision_id INTO l_decision_id;

          RETURN l_item_id;
      EXCEPTION
          WHEN OTHERS THEN
              ROLLBACK TO tps_ai_bounded_exec;
              RAISE;
      END;
  END execute_bounded_add_item;

END tps_ai_programming_tool_pkg;
/
