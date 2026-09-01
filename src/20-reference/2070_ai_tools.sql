/*=============================================================================
 @file              src/20-reference/2070_ai_tools.sql
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-10/16/18
 @workstream        AI reference data / capability catalog
 @source_state      SOURCE_READY_PENDING_RUNTIME_TEST
 @production_state  NOT_DEPLOYED
 @reversibility     R2_STATEFUL reference DML
 @purpose           Ensure the canonical `TPS_PROGRAMMING_TOOL` exists as the logical AI tool
                    identity used by TPS_AI_GUARD_PKG and TPS_AI_PROGRAMMING_TOOL_PKG.
 @business_impact   Gives programming automation a stable governed capability key rather than
                    relying on free-text tool names created at runtime.
 @objects           MERGE rows in TPS_AI_TOOL; currently one canonical programming tool.
 @dependencies      TPS_AI_TOOL.
 @upstream          AI capability architecture.
 @downstream        TPS_AI_AGENT_TOOL grants and TPS_AI_GUARD_PKG authorization.
 @d3ka_role         AI/POLICY
 @d3ka_links        Capability controls access to D3KA-backed programming operations.
 @ai_role           Canonical bounded programming tool metadata.
 @security          Creates no agent grant. Tool existence/ACTIVE state alone does not authorize any agent.
 @performance       One keyed MERGE.
 @transaction       DML only; no COMMIT. Caller/migration owns transaction policy.
 @idempotency       MERGE by TOOL_KEY is repeatable.
 @failure_modes     Missing TPS_AI_TOOL or constraint/privilege failure. Existing row is normalized
                    to canonical class/authority/state deliberately; production change review required.
 @rollback_recovery Restore prior tool metadata/state from migration evidence; do not delete if referenced.
 @tests             tests/ai-control/AIC-001_permission_guard.sql.
 @evidence          CORE-10/16/18 capability catalog evidence.
 @references        Project AI authority architecture and Oracle PL/SQL least-privilege model.
 @links             src/11-ai/1120_tps_ai_tool.sql; src/11-ai/1190_tps_ai_agent_tool.sql;
                    src/11-ai/1191_tps_ai_guard_pkg.pks
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.02 2026-09-01 — initial canonical AI programming tool seed.
=============================================================================*/

MERGE INTO tps_ai_tool t
USING (
    SELECT
        'TPS_PROGRAMMING_TOOL' AS tool_key,
        'PLSQL_PROGRAMMING' AS tool_class,
        'BOUNDED_AUTOMATION' AS authority_class,
        'ACTIVE' AS state
    FROM dual
) s
ON (t.tool_key = s.tool_key)
WHEN MATCHED THEN UPDATE SET
    t.tool_class = s.tool_class,
    t.authority_class = s.authority_class,
    t.state = s.state
WHEN NOT MATCHED THEN INSERT(
    tool_key, tool_class, authority_class, state
) VALUES(
    s.tool_key, s.tool_class, s.authority_class, s.state
);
